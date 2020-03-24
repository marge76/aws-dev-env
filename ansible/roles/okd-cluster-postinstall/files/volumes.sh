for i in `seq 1 200`;
do
    DIRNAME="vol$i"
    mkdir -p /mnt/data/$DIRNAME 
    chcon -Rt svirt_sandbox_file_t /mnt/data/$DIRNAME
    chmod 777 /mnt/data/$DIRNAME
    
    sed "s/name: vol/name: vol$i/g" /tmp/vol.yaml > /tmp/oc_vol.yaml
    sed -i "s/path: \/mnt\/data\/vol/path: \/mnt\/data\/vol$i/g" /tmp/oc_vol.yaml
    oc create -f /tmp/oc_vol.yaml
    echo "created volume $i"
done
rm /tmp/oc_vol.yaml