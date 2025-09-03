## Readme

`gcloud init`

`gcloud auth configure-docker northamerica-northeast1-docker.pkg.dev`

`docker image build --platform=linux/amd64 -t northamerica-northeast1-docker.pkg.dev/athack-ctf-2025/docker/hello-go:latest .`

`docker push northamerica-northeast1-docker.pkg.dev/athack-ctf-2025/docker/hello-go:latest`

`tofu init`

`tofu plan`

`tofu apply`

## To change env var

apply secret change in env.auto.tfvars

`tofu apply` apply the secret change

`tofu apply -replace=helm_release.this` to restart the helm chart

## To Destroy

`tofu destroy -target=helm_release.this -target=kubernetes_secret.this`

`tofu destroy`
