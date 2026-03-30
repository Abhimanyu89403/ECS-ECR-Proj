variable "environment" {
    description = "in which environment the code is"
    type = string
}
variable "cpu" {
    description = "the cpu capacity"
    type = number
}
variable "memory" {
    description = "memory used"
    type = number
}
variable "desired_count" {
    description = "no. of containers running at a single time"
    type = number
}
variable "min_capacity" {
    description = "min capacity of containers scaled"
    type = number
}
variable "max_capacity"{
    description = "max capacity of the containers scaled"
    type = number
}
variable "owner" {
    description = "owner of the microservice"
    type = string
}
variable "team" {
    description = "which team owner belongs to"
    type = string
}
variable "container_port" {
    description = "what port does the container listen to"
    type = number
}