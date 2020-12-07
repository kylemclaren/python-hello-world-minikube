# Python `Hello, World!` on Minikube 🐍

Bootstrap a Python Hello World application on Minikube using Terraform

---

## Prerequisites ✅

All installation scripts assume macOS and a working, running Docker for Desktop installation. The script will install `minikube`, `kubectl` and `terraform` on your system if not present. If you already have those tools installed, please upgrade them to their latest versions before continuing.

---

## What it _does_ 🤷‍♂️

1. Check if `minikube`, `kubectl` and `terraform` are installed locally and install if not.
2. Start a Minikube cluster.
3. Plug into Minikube docker daemon (allowing us to push images from local machine to Minikube).
4. Build docker image for `Hello, World!` app.
5. Start a Minikube loadbalancer.
6. Initialise Terraform.
7. Apply Terraform.
8. Open `Hello, World!` app in default browser.

---

## Terraforming 🌋

Unfortunately, we can't provision the Minikube cluster itself using Terraform, however, we will deploy the `Hello, World!` application as a Kubernetes deployment using Terraform. The `main.tf` file sets up the following infrastructure:

- `apps` namespace
- `hello-world` deployment with 2 replicas, running the `hello-world:1.0.0` image that is built within the Minikube docker context
- `hello-world` service with type `LoadBalancer`

---

## Run it 🚀

> Ensure you are in the `/scripts` directory (`cd scripts`)

```sh
$ sh ./bootstrap.sh
```

<details>
<summary>Example output</summary>
<pre>This is a dropdown with text!</pre>
</details>

---

## Troubleshooting 😫

---

## Known issues 🐞

Zombie tunnel process - the bootstrap scrip spawns a sub-process to run the Minikube tunnel (for loadbalancing). This command continues to run after the bootstrap script has exited. Will become a zombie proc after minikube cluster is deleted, so this can/should be improved. To manually kill the command, run `ps aux | grep "minikube tunnel"`, note the proc ID, and then `kill -9 <PROC>`

Running the `cleanup.sh` script solves this issue by killing the proc.

---

## Cleaning up 🧹

> Ensure you are in the `/scripts` directory (`cd scripts`)

```sh
$ sh ./cleanup.sh
```

---

## Going Further 🦾

- Set up a local image registry or enable credential input for remote registry to push images to
- Use `xip.io`
- Secure app with self-signed certs
- Enable Istio on cluster to manage traffic/load balancing
- Setup CI/CD and deploy app using ArgoCD
