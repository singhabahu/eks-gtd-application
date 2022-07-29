terraform {
  source = "../../../infrastructure/modules//vpc"
}

include "root" {
  path = find_in_parent_folders()
}
