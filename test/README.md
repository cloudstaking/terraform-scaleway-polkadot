# Infrastructure tests

When changes happen, it is important to run infrastructure tests in order verify main components are still working as expected:

- Disk size 
- Tools installed (docker, docker-compose, polkadot binaries, nginx, caddy, etc)

## How to run the tests

```sh
$ go test -v -timeout 30m
...
```
