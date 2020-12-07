# Python `Hello, World!` on Minikube 🐍

Bootstrap a Python Hello, World! application on Minikube using Terraform

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
<pre>
➜  scripts git:(master) ✗ sh ./bootstrap.sh
Attempting to install minikube and assorted tools to /usr/local/bin
kubetcl is already installed
minikube is already installed
Attempting to install Terraform to /usr/local/bin
Terraform is already installed
Starting minikube...
😄  minikube v1.15.1 on Darwin 10.15.7
✨  Automatically selected the docker driver. Other choices: hyperkit, virtualbox
👍  Starting control plane node minikube in cluster minikube
🔥  Creating docker container (CPUs=2, Memory=1987MB) ...
❗  This container is having trouble accessing https://k8s.gcr.io
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
🐳  Preparing Kubernetes v1.19.4 on Docker 19.03.13 ...
🔎  Verifying Kubernetes components...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
🙄  No changes required for the "minikube" context
💗  Current context is "minikube"
Building Docker image...
Sending build context to Docker daemon  5.632kB
Step 1/7 : FROM python:3.6
3.6: Pulling from library/python
756975cb9c7e: Pull complete
d77915b4e630: Pull complete
5f37a0a41b6b: Pull complete
96b2c1e36db5: Pull complete
c495e8de12d2: Pull complete
a79e1025c0fe: Pull complete
f1f619b13c7c: Pull complete
1f74591d7ee0: Pull complete
5ce9e9a2fdaa: Pull complete
Digest: sha256:eea8761e62da5990ce1fae2d278de877415b15ab5c9f54e0efdd012ff478ed93
Status: Downloaded newer image for python:3.6
 ---> bda27a013ab2
Step 2/7 : LABEL maintainer="kylemclaren@protonmail.com"
 ---> Running in 9a0f24971e4b
Removing intermediate container 9a0f24971e4b
 ---> 1f045bdfe198
Step 3/7 : COPY . /app
 ---> ee068222e09a
Step 4/7 : WORKDIR /app
 ---> Running in 08c09c1e8eaa
Removing intermediate container 08c09c1e8eaa
 ---> 92724a274a79
Step 5/7 : RUN pip install -r requirements.txt
 ---> Running in 3eb53b4575a5
Collecting flask
  Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
Collecting click>=5.1
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting itsdangerous>=0.24
  Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
Collecting Jinja2>=2.10.1
  Downloading Jinja2-2.11.2-py2.py3-none-any.whl (125 kB)
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1-cp36-cp36m-manylinux1_x86_64.whl (27 kB)
Collecting Werkzeug>=0.15
  Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
Installing collected packages: MarkupSafe, Werkzeug, Jinja2, itsdangerous, click, flask
Successfully installed Jinja2-2.11.2 MarkupSafe-1.1.1 Werkzeug-1.0.1 click-7.1.2 flask-1.1.2 itsdangerous-1.1.0
Removing intermediate container 3eb53b4575a5
 ---> af4a58845f46
Step 6/7 : ENTRYPOINT ["python"]
 ---> Running in 9e8f98ce35b6
Removing intermediate container 9e8f98ce35b6
 ---> d293ff78db37
Step 7/7 : CMD ["app.py"]
 ---> Running in e5e68afd9b87
Removing intermediate container e5e68afd9b87
 ---> 782825373293
Successfully built 782825373293
Successfully tagged hello-world:1.0.0
Starting minikube loadbalancer...
Loadbalancer started...

Initializing the backend...

Initializing provider plugins...

- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Installing hashicorp/kubernetes v1.13.3...
- Installed hashicorp/kubernetes v1.13.3 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Terraform apply...
kubernetes_namespace.k8s-apps-namespace: Refreshing state... [id=apps]
kubernetes_deployment.hello-world: Refreshing state... [id=apps/hello-world]
kubernetes_service.hello-world: Refreshing state... [id=apps/hello-world]
kubernetes_namespace.k8s-apps-namespace: Creating...
kubernetes_namespace.k8s-apps-namespace: Creation complete after 0s [id=apps]
kubernetes_deployment.hello-world: Creating...
kubernetes_deployment.hello-world: Creation complete after 4s [id=apps/hello-world]
kubernetes_service.hello-world: Creating...
kubernetes_service.hello-world: Creation complete after 1s [id=apps/hello-world]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

lb_ip = "127.0.0.1"
Opening 'Hello, World!' in default browser...

</pre>
</details>

---

## Inspect things 🔎

```sh
$ kubectl get pods -n apps
```

```txt
NAME                           READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
hello-world-6664cb549c-k7tgl   1/1     Running   0          13m   172.17.0.4   minikube   <none>           <none>
hello-world-6664cb549c-nr8vt   1/1     Running   0          13m   172.17.0.3   minikube   <none>           <none>

```

```sh
$ kubectl describe pods hello-world-6664cb549c-k7tgl
```

```txt
Name:         hello-world-6664cb549c-k7tgl
Namespace:    apps
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Tue, 08 Dec 2020 00:25:50 +0200
Labels:       App=helloWorldApp
              pod-template-hash=6664cb549c
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:           172.17.0.4
Controlled By:  ReplicaSet/hello-world-6664cb549c
Containers:
  hello-world-app:
    Container ID:   docker://6692ce37631564669ebdee6f8bb93b8608a156749223c9e755c2d90c7afc1f88
    Image:          hello-world:1.0.0
    Image ID:       docker://sha256:501415638a9b51f6a57152064b07d89fd35fb4213a4e676b9c0ee26b04614389
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 08 Dec 2020 00:25:51 +0200
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     500m
      memory:  512Mi
    Requests:
      cpu:        250m
      memory:     50Mi
    Environment:  <none>
    Mounts:       <none>
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:            <none>
QoS Class:          Burstable
Node-Selectors:     <none>
Tolerations:        node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                    node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  14m   default-scheduler  Successfully assigned apps/hello-world-6664cb549c-k7tgl to minikube
  Normal  Pulled     14m   kubelet            Container image "hello-world:1.0.0" already present on machine
  Normal  Created    14m   kubelet            Created container hello-world-app
  Normal  Started    14m   kubelet            Started container hello-world-app

```

---

## Troubleshooting 😫

If `bootstrap.sh` fails with a permission error of some kind, please run it again with sudo:

> ❗️ Always inspect scripts before running them in your terminal, especially when running with sudo!!

```sh
$ sudo !!
```

> OR

```sh
$ sudo sh ./boostrap.sh
```

---

## Known issues 🐞

Zombie tunnel process - the bootstrap script spawns a sub-process to run the Minikube tunnel (for loadbalancing). This command continues to run after the bootstrap script has exited. Will become a zombie proc after minikube cluster is deleted, so this can/should be improved. To manually kill the command, run `ps aux | grep "minikube tunnel"`, note the proc ID, and then `kill -9 <PROC>`

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
- ngrok
- Enable Istio on cluster to manage traffic/load balancing
- Setup CI/CD and deploy app using ArgoCD
