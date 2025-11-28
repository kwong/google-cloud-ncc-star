# google-cloud-ncc-star

## Overview
NCC Use case testing 

## Use cases

### Hub and spoke with central egress

#### Topology
Star (edge spokes cannot communicate with each other)

#### Components
- Workload VPC spoke A
- Workload VPC spoke B
- Shared Services VPC spoke
- Transit VPC
- On-premise Network (Simulated using VPC)

#### Test cases
1. Reachability to Shared Services VPC
2. Reachability to on-premise network
3. Reachability to internet public IP via central Cloud NAT
