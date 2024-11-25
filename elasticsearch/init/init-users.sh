#!/bin/bash

# 定义用户名、密码和角色
KIBANA_USER="kibana_system"
KIBANA_PASSWORD="123456"
ROLE="kibana_system"
ELASTIC_PASSWORD="123456"

# 等待 Elasticsearch 启动
until curl -u "elastic:${ELASTIC_PASSWORD}" -X GET "http://localhost:9200/_cluster/health" | grep -q '"status":"green"'
do
  echo "等待 Elasticsearch 启动..."
  sleep 5
done

# 检查用户是否已经存在
USER_EXISTS=$(curl -u "elastic:${ELASTIC_PASSWORD}" -X GET "http://localhost:9200/_security/user/${KIBANA_USER}" -o /dev/null -w '%{http_code}' -s)

if [ "$USER_EXISTS" -eq 200 ]; then
  # 创建 Kibana 用户
  curl -u "elastic:${ELASTIC_PASSWORD}" -X POST "http://localhost:9200/_security/user/${KIBANA_USER}/_password" \
    -H "Content-Type: application/json" \
     -d "{
      \"password\" : \"${KIBANA_PASSWORD}\"
    }"
  echo "修改 Kibana 用户密码完成。"
else
  echo "用户 ${KIBANA_USER} 已经存在，跳过创建。"
fi

# ---------- end 分割线 ----------


#curl -u "elastic:123456" -X GET "http://localhost:9200/_security/user/kibana_system"