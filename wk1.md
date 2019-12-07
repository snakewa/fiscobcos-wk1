

## Fiscos bcos build_chain.sh的簡單分析

一句話：Ficos bcos環境生成器!
source: https://github.com/FISCO-BCOS/FISCO-BCOS/blob/master/tools/build_chain.sh


## Bash組成



*   Functions line 0 ~ 1000
    *   help()
    *   parse_params()
    *   print_result()
    *   check_env() 
    *   生成證書類 gen_*_cert_*() , gen_*_cert_*_gm() 國密版
    *   生成script或配置檔類 generate_*()
*   Main line 1000 ~ 1200


## 主要Main: 1000-1200行



*   例子：build_chain.sh -l "127.0.0.1:4" -p 30300,20200,8545
*   必須要有有網路
*   某些平台支持Docker mode
*   下載fiscos的execute binary
    *   Download: download_bin()
    *   Verify: check_bin()
*   生成証書 generate_cert_conf "cert.cnf"
*   use_ip_param
    *   
*   生成CA証書 
    *   gen_chain_cert()
    *   gen_agency_cert()
    *   Guomi_mode 国密版 [https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/manual/guomi_crypto.html](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/manual/guomi_crypto.html)
        *   Check_and_install_tassl
            *   Tassl就是国密版 Openssl [http://www.tass.com.cn/portal/research/viewpoint_view-36.html](http://www.tass.com.cn/portal/research/viewpoint_view-36.html)
                *   SM4秘钥长度是128bit，安全性相当于AES128.
                *   SM2是一种ECC，使用时安全性取决于你用的是密钥长度。对应ECC那一列即可。
                *   SM3是一种hash算法。相当于国际上的SHA-256吧。hash算法都有同样的问题，会丢失熵。所以，会发生碰撞。这完全是是另一个话题了。
        *   gen_chain_cert_gm()
        *   Gen_agency_cert_gm()
*   生成各個node的密鑰
    *   nodeid格式
    *   For loop: Nodeid_list 
        *   gen_cert()
*   生成配置檔案
    *   generate_config_ini
    *   generate_group_genesis
    *   generate_group_ini
    *   generate_node_scripts
    *   generate_server_scripts


![生成的目錄](https://i.imgur.com/TDXUvgx.png)


## 其它的bash function



*   Parse_params
    *   -l <IP list>                        [Required] "ip1:nodeNum1,ip2:nodeNum2" e.g:"192.168.0.1:2,192.168.0.2:3"
    *   -p <Start Port>                     Default 30300,20200,8545 means p2p_port start from 30300, channel_port from 20200, jsonrpc_port from 8545
