paas_space                    = "get-into-teaching-production"
paas_adviser_application_name = "get-teacher-training-adviser-service-prod"
paas_adviser_route_name       = "get-teacher-training-adviser-service-prod"
paas_linked_services          = ["get-into-teaching-prod-redis-svc", "get-into-teaching-api-prod-pg-common-svc"]
paas_additional_route_names   = ["beta-adviser-getintoteaching", "adviser-getintoteaching"]
logging                       = 1
instances                     = 2
azure_key_vault               = "s146p01-kv"
azure_resource_group          = "s146p01-rg"
alerts = {
  GiT_TTA_Production_Healthcheck = {
    website_name  = "Get Into Teaching Adviser (Production)"
    website_url   = "https://adviser-getintoteaching.education.gov.uk/healthcheck.json"
    test_type     = "HTTP"
    check_rate    = 60
    contact_group = [185037]
    trigger_rate  = 0
    confirmations = 1
    custom_header = "{\"Content-Type\": \"application/x-www-form-urlencoded\"}"
    status_codes  = "204, 205, 206, 303, 400, 401, 403, 404, 405, 406, 408, 410, 413, 444, 429, 494, 495, 496, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 521, 522, 523, 524, 520, 598, 599"
  }
}
