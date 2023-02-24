
variable "name" {
  description = "Name of cluster to create"
  type = string
}

variable "region" {
  description = "GCP Region for deployment"
  type = string
}

variable "project" {
  description = "GCP Project"
  type = string
}

variable "enable_autopilot" {
  description = "Enable GKE Autopilot (default false)"
  type = bool
  default = false
}

variable "authorized_networks" {
  description = "Map of networks to access control plane."
  type = map(string)
  default = {
    "Harness Office 1" = "192.195.83.11/32"
    "Harness Office 2" = "207.242.51.98/32"
    "Prod NAT IP 1" = "104.196.233.194/32"
    "Prod NAT IP 2" = "35.233.202.245/32"
    "Harness Office Blr" = "125.19.67.142/32"
    "staging-delegate-1" = "35.197.25.142/32"
    "staging-delegate-2" = "35.212.161.151/32"
    "prod-all-cluster-vm-delegate" = "35.233.164.9/32"
    "QA Cluster Cloud NAT" = "35.233.145.199/32"
    "QB Cluster Cloud NAT" = "35.230.101.175/32"
    "uat-cvng-delegate" = "34.82.71.95/32"
    "stage-nat-1" = "35.233.182.198/32"
    "stage-nat-2" = "35.203.167.5/32"
    "PR Cluster Cloud NAT 1" = "35.225.75.226/32"
    "PR Cluster Cloud NAT 2" = "35.222.86.194/32"
    "PR Cluster Cloud NAT 3" = "34.123.227.98/32"
    "UAT NAT IP" = "35.192.212.183/32"
    "UAT NAT IP 2" = "34.71.56.89/32"
    "SFO" = "65.115.92.26/32"
    "vpn-gcp-vmx" = "34.93.204.95/32"
    "Failover NAT IP 1" = "35.236.117.224/32"
    "Failover NAT IP 2" = "35.236.112.238/32"
    "Failover NAT IP 3" = "34.94.29.95/32"
    "Failover NAT IP 4" = "34.94.190.229/32"
    "VPN AMER" = "35.236.90.71/32"
    "VPN EMEA" = "35.197.221.21/32"
    "Orlando"  = "172.2.219.129/32"
  }

}