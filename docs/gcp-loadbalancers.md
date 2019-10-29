# GCP Load balancers

TODO

## Network load balancer

create multiple webservers - targets to be balanced

```bash
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF
```

### create instance templates

gcloud compute instance-templates create nginx-template \
         --metadata-from-file startup-script=startup.sh

### target pool

gcloud compute target-pools create nginx-pool

### managed instance group

gcloud compute instance-groups managed create nginx-group \
         --base-instance-name nginx \
         --size 2 \
         --template nginx-template \
         --target-pool nginx-pool

!!!Note
    Layer 3 network load balancer consist of an instance group with forwarding rules

It supports low level access - inspects packets

```bash tab="*nix"
gcloud compute forwarding-rules create nginx-lb \
         --region us-central1 \
         --ports=80 \
         --target-pool nginx-pool
```

```bash tab="Powershell"
gcloud compute forwarding-rules create nginx-lb \
         --region us-central1 \
         --ports=80 \
         --target-pool nginx-pool
```

gcloud compute forwarding-rules list

## setup http load balancer layer 7

### create health check

gcloud compute http-health-checks create http-basic-check

### define http service and port mappings

gcloud compute instance-groups managed \
       set-named-ports nginx-group \
       --named-ports http:80

### create backend service

gcloud compute backend-services create nginx-backend \
      --protocol HTTP --http-health-checks http-basic-check --global

### add instance group to service

gcloud compute backend-services add-backend nginx-backend \
    --instance-group nginx-group \
    --instance-group-zone us-central1-a \
    --global

### add urlmaps

gcloud compute url-maps create web-map \
    --default-service nginx-backend

### create http proxy for routing

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map

### forwarding rule

gcloud compute forwarding-rules create http-content-rule \
        --global \
        --target-http-proxy http-lb-proxy \
        --ports 80

<https://google.qwiklabs.com/focuses/4798?parent=catalog>
