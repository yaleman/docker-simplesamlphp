simplesamlphp test environment

This repo sets up a test environment to test simplesamlphp. It creates four services:
 - idp.tutorial.stack-dev.cirrusidentity.com
 - proxy.tutorial.stack-dev.cirrusidentity.com
 - sp1.tutorial.stack-dev.cirrusidentity.com
 - sp2.tutorial.stack-dev.cirrusidentity.com

all available in your browser. proxy and sp1 is setup to use idp as idp, while sp2 uses proxy as idp.

To get started put the version of simplesamlphp you want to test in a
folder named `simplesamlphp`. Then run `docker-compose up -d`. The
`ca` folder should now contain a `ca.pem` file you can import in your
browser to https access. Then point your browser at
https://sp1.tutorial.stack-dev.cirrusidentity.com or
https://sp2.tutorial.stack-dev.cirrusidentity.com to start testing.

# Usage

```bash
#clone this repo
git clone https://github.com/yaleman/docker-simplesamlphp
cd docker-simplesamlphp
# clone simplesamlphp
git clone https://github.com/simplesamlphp/simplesamlphp
cd simplesamlphp
# grab the version you want to test
git switch -c simplesamlphp-1.18
# start it up
cd ..
docker-compose up --build
```
