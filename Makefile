ENV_FILE := .env
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})

# NOTE: the actual commands here have to be indented by TABs
.PHONY: oc_login_1
oc_login_1:
ifdef OC_TOKEN_1
	$(info **** Using OC_TOKEN for login ****)
	oc login ${OC_URL_1} --token=${OC_TOKEN_1}
else
	$(info **** Using OC_USER and OC_PASSWORD for login ****)
	oc login ${OC_URL_1} -u ${OC_USER_1} -p ${OC_PASSWORD_1} --insecure-skip-tls-verify=true
endif

.PHONY: oc_login_2
oc_login_2:
ifdef OC_TOKEN_2
	$(info **** Using OC_TOKEN for login ****)
	oc login ${OC_URL_2} --token=${OC_TOKEN_2}
else
	$(info **** Using OC_USER and OC_PASSWORD for login ****)
	oc login ${OC_URL_2} -u ${OC_USER_2} -p ${OC_PASSWORD_2} --insecure-skip-tls-verify=true
endif

cluster_1: oc_login_1
	./deploy-g1.sh

cluster_2: oc_login_2
	./deploy-g2.sh

db: oc_login_1
	./db-schema.sh

backend: oc_login_2
	./deploy-backend.sh

frontend: oc_login_2
	./deploy-frontend.sh

expose: oc_login_2
	./expose.sh

clean_1: oc_login_1
	./clean_1.sh
