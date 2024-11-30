.PHONY: tofu-run tofu-destroy ansible-run all

tofu-run:
	cd OpenTofu && tofu init && tofu plan && tofu apply && virsh list --all


tofu-destroy:
	cd OpenTofu && tofu destroy

ansible-run:
	cd Ansible && ansible-playbook -i inventory.ini playbooks.yml -vvv

all: tofu-run ansible-run
