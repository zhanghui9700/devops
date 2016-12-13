### how to run ansible mixportal role

    edit vars/main.yml
    
    ANSIBLE_ROLES_PATH=`pwd` ansible-playbook -i hosts -s deploy.yml
