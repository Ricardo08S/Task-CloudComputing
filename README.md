# Cloud-Computing 2024

## Requirement

- Ubuntu 20.04 LTS atau lebih baru
- Debian 10 atau lebih baru
- CentOS 7 atau lebih baru
- Libvirt & KVM <br>
  (Instalasi Libvirt & KVM)
  KVM (Kernel-based Virtual Machine): Hypervisor yang digunakan untuk menjalankan mesin virtual.
    ```
    sudo apt-get install qemu-kvm libvirt-bin
    ```
  Libvirt: Untuk mengelola mesin virtual.
    ```
    sudo apt-get install libvirt-dev libvirt-bin libvirt-clients bridge-utils virtinst virt-manager
    ```
  Virt-Manager: Alat GUI untuk mengelola mesin virtual.
    ```
    sudo apt-get install virt-manager
    ```
- OpenTofu <br>
  (Instalasi OpenTofu)
  ```
  sudo apt-get install opentofu
  ```
- Ansible (Terbaru) <br>
  Dapat menggunakan pip3
  ```
  sudo apt update
  sudo apt install python3-pip -y
  pip3 install ansible
  ```
  Atau menggunakan pipx
  ```
  sudo apt update
  sudo apt install python3-pip -y
  python3 -m pip install --user pipx
  pipx install ansible
  ```

## How to run

1. First provisioning VM
    ```
    make tofu-run
    ```
2. Configuration for Webserver & Database
    ```
    make ansible-run
    ```
3. If done, don't forget to destroy the VM
    ```
    make tofu-destroy
    ```


## Catatan:

Pastikan telah terinstall libvirt

Lakukan konfigurasi pada `/etc/libvirt/storage/default_storage_pool.xml` <br>
Bisa menggunakan template dengan melakukan konfigurasi
```
getent passwd libvirt-qemu
getent group libvirt
```
untuk dimasukkan ke dalam `default_storage_pool.xml` lalu jalankan
```
cp OpenTofu/configuration-script/default_storage_pool.xml /etc/libvirt/storage/default_storage_pool.xml
```

Untuk Cek Status OpenTofu:
```
sudo systemctl status libvirtd
```

Untuk Buat Storage pool pertama kali :
```
sudo virsh pool-define /etc/libvirt/storage/default_storage_pool.xml
sudo virsh pool-start default
sudo virsh pool-autostart default
```

Untuk Cek Storage pool :
```
virsh vol-list default
virsh pool-info default
```

Jika Fail (storage pool 'default' already exists), Debug dengan cara :
```
sudo virsh pool-list --all
sudo virsh pool-destroy default
sudo virsh pool-undefine default
```

Untuk Cek VM yang sedang running :
```
virsh list
```

Untuk Ansible jangan lupa samakan ip, user, dan password vm dengan yang telah dibuat dari OpenTofu

Thank You!!!!