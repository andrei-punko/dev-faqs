# OpenShift

## Local cluster (CRC)

- Install: [Red Hat — CRC, installer-provisioned](https://cloud.redhat.com/openshift/install/crc/installer-provisioned)

### Setup steps (Windows)

- Downloaded archive, extracted to folder in Program Files.
- Added executables to `$PATH`.
- Switched on Hyper-V.
- Added current user to Hyper-V administrators, log out + log in.
- Run `crc setup`.
- Run `crc start --nameserver 1.1.1.1`, paste copied pull secret.
  - For debugging: `crc start --log-level debug`.
  - If start failed: stop the VM from Hyper-V UI and recreate it via `crc` commands.

### Message after a successful start

```text
Started the OpenShift cluster

To access the cluster, first set up your environment by following the instructions returned by executing 'crc oc-env'.
Then you can access your cluster by running 'oc login -u developer -p developer https://api.crc.testing:6443'.
To login as a cluster admin, run 'oc login -u kubeadmin -p HqC3I-wgtiB-q7qCf-KEsuK https://api.crc.testing:6443'.

You can also run 'crc console' and use the above credentials to access the OpenShift web console.
The console will open in your default browser.
```

### Configure `oc` in cmd

```bat
@FOR /f "tokens=*" %i IN ('crc oc-env') DO @call %i
```

After that you can log in as developer or admin.

### First login and project

```text
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

Create a new project:

```bash
oc new-project andrei-test-project
```

```text
Now using project "andrei-test-project" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname
```

Add an application to the project:

```bash
oc new-app rails-postgresql-example
```

```text
--> Deploying template "openshift/rails-postgresql-example" to project andrei-test-project

     Rails + PostgreSQL (Ephemeral)
     ---------
     An example Rails application with a PostgreSQL database. For more information about using this template, including OpenShift considerations, see https://github.com/sclorg/rails-ex/blob/master/README.md.
```

Stop the cluster:

```bash
crc stop
```

---

## Ansible Vault (encode / decode)

- [ansible-vault-tool.com](https://ansible-vault-tool.com)
- Internal tool: `https://ansible-vault-tool-v2.dso-core.apps.d0-oscp.corp.dev.vtb` — password in notes: `qwerty`.

IntelliJ plugin for pack/unpack of values in Secrets: [Ansible Vault Editor](https://plugins.jetbrains.com/plugin/14278-ansible-vault-editor).
