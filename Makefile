ENV_FILE := .env
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})

# NOTE: the actual commands here have to be indented by TABs
.PHONY: oc_login_1
oc_login_1:
ifdef OC_TOKEN_1
	$(info **** Using OC_TOKEN for login ****)
	oc login ${OC_URL_1} --token=${OC_TOKEN_1}
	oc project todo
else
	$(info **** Using OC_USER and OC_PASSWORD for login ****)
	oc login ${OC_URL_1} -u ${OC_USER_1} -p ${OC_PASSWORD_1} --insecure-skip-tls-verify=true
	oc project todo
endif

.PHONY: oc_login_2
oc_login_2:
ifdef OC_TOKEN_2
	$(info **** Using OC_TOKEN for login ****)
	oc login ${OC_URL_2} --token=${OC_TOKEN_2}
	oc project todo
else
	$(info **** Using OC_USER and OC_PASSWORD for login ****)
	oc login ${OC_URL_2} -u ${OC_USER_2} -p ${OC_PASSWORD_2} --insecure-skip-tls-verify=true
	oc project todo
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

clean_2: oc_login_2
	./clean_2.sh

deploy_single_cockroachdb: oc_login_1
	./deploy-single-cockroachdb-cluster.sh

deploy_backend_1: oc_login_1
	kubectl apply -f todo-backend/src/main/kubernetes/backend-aws.yaml
	kubectl annotate deployment todo-backend skupper.io/proxy=http

deploy_backend_2: oc_login_2
	kubectl apply -f todo-backend/src/main/kubernetes/backend-gcp.yaml
	kubectl annotate deployment todo-backend skupper.io/proxy=http

frontend_1: oc_login_1
	./deploy-frontend.sh

expose_1: oc_login_1
	./expose.sh

backend_cluster_1: oc_login_1
	./skupperize-backend-1.sh

backend_cluster_2: oc_login_2
	./skupperize-backend-2.sh

create_namespace_1: oc_login_1
	kubectl create namespace todo

create_namespace_2: oc_login_2
	kubectl create namespace todo

## You can only one of the next commands

# To use the demo with failover on persistence layer (cockroachdb cluster) 
cockroach-hybrid: create_namespace_1 create_namespace_2 cluster_1 cluster_2 db backend frontend expose

# To use the demo with failover in the backend

backend-hybrid: create_namespace_1 create_namespace_2 deploy_single_cockroachdb db deploy_backend_1 frontend_1 expose_1 backend_cluster_1 backend_cluster_2 deploy_backend_2