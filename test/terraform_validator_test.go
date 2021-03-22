package main

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestValidator deploys a validator and check the basic things like: disk space, tools
// (docker/docker-compose/etc)
func TestSimpleValidator(t *testing.T) {
	t.Parallel()

	instanceName := fmt.Sprintf("validator-%s", strings.ToLower(random.UniqueId()))

	// Generate SSH keypairs
	keyPair := ssh.GenerateRSAKeyPair(t, 2048)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/simple-validator",
		Vars: map[string]interface{}{
			"ssh_key":       keyPair.PublicKey,
			"instance_name": instanceName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	publicInstanceIP := terraform.Output(t, terraformOptions, "public_ip")

	publicHost := ssh.Host{
		Hostname:    publicInstanceIP,
		SshKeyPair:  keyPair,
		SshUserName: "ubuntu",
	}

	maxRetries := 30
	timeBetweenRetries := 30 * time.Second

	description := fmt.Sprintf("SSHing to validator %s to check if docker & docker-compose are installed", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkBinaries(t, publicHost)
	})

	description = fmt.Sprintf("SSHing in validator (%s) to check if application files exist", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkAppFiles(t, publicHost)
	})
}

// TestValidatorWithPolkashots deploys a validator and enable polkashots and also additional volume
func TestValidatorWithPolkashots(t *testing.T) {
	t.Parallel()

	instanceName := fmt.Sprintf("validator-%s", strings.ToLower(random.UniqueId()))

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/extra-volume-and-polkashot",
		Vars: map[string]interface{}{
			"ssh_key":       keyPair.PublicKey,
			"instance_name": instanceName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	publicInstanceIP := terraform.Output(t, terraformOptions, "public_ip")

	publicHost := ssh.Host{
		Hostname:    publicInstanceIP,
		SshKeyPair:  keyPair,
		SshUserName: "ubuntu",
	}

	maxRetries := 30
	timeBetweenRetries := 30 * time.Second
	description := fmt.Sprintf("SSHing to validator %s to check disk size", publicInstanceIP)

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkDiskSize(t, publicHost, 190000000) // 190G
	})

	description = fmt.Sprintf("SSHing to validator %s to check if docker & docker-compose are installed", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkBinaries(t, publicHost)
	})

	description = fmt.Sprintf("SSHing to validator (%s) to check if snapshot folder exist and >5GB", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkPolkadotSnapshot(t, publicHost)
	})

	description = fmt.Sprintf("SSHing in validator (%s) to check if application files exist", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkAppFiles(t, publicHost)
	})
}
