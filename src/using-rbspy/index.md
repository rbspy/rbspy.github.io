# Using rbspy

## Subcommands

`rbspy` has three subcommands: `snapshot`, `record`, and `report`.

[**snapshot**](./snapshot.md) takes a single stack trace from the specified process, prints it, and exits. This is useful if you have a stuck Ruby program and just want to know what it's doing right now.

[**record**](./record.md) continuously captures stack traces from your process and saves them to disk. It's used to profile a program over a period of time and to produce a flamegraph or other output for offline analysis.

[**report**](./report.md) is useful if you have a raw rbspy data file that you've previously recorded. You can use `rbspy report` to generate different kinds of visualizations from it, as documented in the [record](./record.md#optional-arguments) section. This is useful because you can record raw data from a program and then decide how you want to visualize it afterwards.

## Containers

If you want to profile a ruby program that's running in a container on Linux, be sure to add the `SYS_PTRACE` capability.

For Docker containers, this can be done by adding a flag to the command when you launch the container:

```
docker run --cap-add=SYS_PTRACE ...
```

If your Docker containers start up through Docker Compose, you can add the flag to the relevant container(s) in `docker-compose.yml`:

```
services:
  ruby_container_name:
    ...
    other_config_here
    ...
    cap_add:
      - SYS_PTRACE
```

If you're using Kubernetes, you can add the ptrace capability to a deployment like this:

```
securityContext:
  capabilities:
    add:
      - SYS_PTRACE
```

If this doesn't work for you, see [issue 325](https://github.com/rbspy/rbspy/issues/325) for troubleshooting steps. You may need additional `securityContext` configuration if the processes in your container are running as an unprivileged (non-root) user, which is recommended for security reasons.
