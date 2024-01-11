locals {
    name = "${var.project_name}-${var.environment}"
     az_names = slice(data.aws_availability_zones.azs.names,0,2) #include 0 and exclude 2 position means 0, 1 index data will come in this list.
}