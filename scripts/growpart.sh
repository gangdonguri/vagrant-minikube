if [[ -b /dev/vda3 ]]; then
  sudo growpart /dev/vda3
  sudo resize2fs /dev/vda3
elif [[ -b /dev/sda3 ]]; then
  sudo growpart /dev/sda3
  sudo resize2fs /dev/sda3
fi