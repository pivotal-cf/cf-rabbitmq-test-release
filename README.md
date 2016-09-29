A BOSH release for testing [cf-rabbitmq release](https://github.com/pivotal-cf/cf-rabbitmq-release).

There are jobs in this release that you will want to co-locate when testing
jobs from other releases. For example, to test `syslog_forwarder` job from
syslog release, you will want to co-locate `syslog-configuration-test` job from
this release:

```
rmq-server/0 (instance)
|- syslog_forwarder (syslog release)
\- syslog-configuration-test (cf-rabbitmq-test release)
```

You can see a configuration example in the [cf-rabbitmq-release
manifest](https://github.com/pivotal-cf/cf-rabbitmq-release/blob/master/manifests/cf-rabbitmq.yml)

Your BOSH Director will need to have [`post_deploy` enabled](https://bosh.io/docs/post-deploy.html).
