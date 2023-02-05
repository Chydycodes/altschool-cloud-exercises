#!/bin/bash

export META_INST_AZ=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`
export META_INST_PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
export META_INST_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

document='index.html'
appname='mini-project'
cd /var/www/html
rm -r ${document}
echo "<!DOCTYPE html>" >> ${document}
echo "<html lang="en">" >> ${document}
echo "<head>" >> ${document}
echo "    <meta charset="UTF-8">" >> ${document}
echo "    <meta name="viewport" content="width=device-width, initial-scale=1.0">" >> ${document}
echo "    <style>" >> ${document}

echo "        .wrapper {" >> ${document}
echo "            width: 100%;" >> ${document}
echo "            width: 100%;" >> ${document}
echo "            height: auto;" >> ${document}
echo "            min-height: 90vh;" >> ${document}
echo "            padding: 50px 20px;" >> ${document}
echo "            padding-top: 100px;" >> ${document}
echo "            display: flex;" >> ${document}
echo "        }" >> ${document}

echo "        .instance-card {" >> ${document}
echo "            width: 100%;" >> ${document}
echo "            min-height: 380px;" >> ${document}
echo "            margin: auto;" >> ${document}
echo "            max-width: 500px;" >> ${document}
echo "            position: relative;" >> ${document}
echo "        }" >> ${document}

echo "        .instance-card__cnt {" >> ${document}
echo "            margin-top: 35px;" >> ${document}
echo "            text-align: center;" >> ${document}
echo "            padding: 0 20px;" >> ${document}
echo "            padding-bottom: 20px;" >> ${document}
echo "        }" >> ${document}

echo "        .instance-card__name {" >> ${document}
echo "            color: purple;" >> ${document}
echo "            margin-bottom: 9px;" >> ${document}
echo "        }" >> ${document}

echo "        .instance-card-inf__item {" >> ${document}
echo "            padding: 5px;" >> ${document}
echo "            min-width: 150px;" >> ${document}
echo "        }" >> ${document}

echo "        .instance-card-inf__title {" >> ${document}
echo "            color: #324e63;" >> ${document}
echo "        }" >> ${document}

echo "        .instance-card-inf__txt {" >> ${document}
echo "            font-weight: 500;" >> ${document}
echo "            margin-top: 7px;" >> ${document}
echo "        }" >> ${document}

echo "    </style>" >> ${document}
echo "    <title>${appname}</title>" >> ${document}
echo "</head>" >> ${document}
echo "<body>" >> ${document}
echo "    <div class="wrapper">" >> ${document}
echo "        <div class="instance-card">" >> ${document}
echo "            <div class="instance-card__cnt">" >> ${document}
echo "                <div class="instance-card__name">Instance $META_INST_ID is running!</div>" >> ${document}
echo "                <div class="instance-card-inf">" >> ${document}


echo "                    <div class="instance-card-inf__item">" >> ${document}
echo "                        <div class="instance-card-inf__txt">Public IP</div>" >> ${document}
echo "                        <div class="instance-card-inf__title">" $META_INST_PUBLIC_IP "</div>" >> ${document}
echo "                    </div>" >> ${document}

echo "                    <div class="instance-card-inf__item">" >> ${document}
echo "                        <div class="instance-card-inf__txt">Availability zone</div>" >> ${document}
echo "                        <div class="instance-card-inf__title">" $META_INST_AZ "</div>" >> ${document}
echo "                    </div>" >> ${document}

echo "                </div>" >> ${document}
echo "            </div>" >> ${document}
echo "        </div>" >> ${document}
echo "</body>" >> ${document}
echo "</html>" >> ${document}

systemctl restart apache2
