#!/bin/bash

set -e

LOG_START='\n\e[1;36m' # new line + bold + color
LOG_END='\n\e[0m' # new line + reset color
DONE_START='\n\e[1;32m' # new line + bold + green
DONE_END='\n\n\e[0m'    # new line + reset

WORKDIR=$PWD

printf "${LOG_START}Installing dependencies for dApp...${LOG_END}"
yarn

printf "${LOG_START}Checking out keep-subgraph:for-allthekeeps-on-ropsten branch...${LOG_END}"

cd keep-subgraph
git co for-allthekeeps-on-ropsten

printf "${LOG_START}Running subgraph scripts...${LOG_END}"

SUBGRAPH_API=`CONTRACT_OWNER_ETH_ACCOUNT_PRIVATE_KEY=${CONTRACT_OWNER_ETH_ACCOUNT_PRIVATE_KEY} ETH_RPC_URL=${ETH_RPC_URL} SUBGRAPH_DEPLOY_KEY=${SUBGRAPH_DEPLOY_KEY} SUBGRAPH_SLUG=${SUBGRAPH_SLUG} ./deploy-subgraph.sh`

printf "${LOG_START}Creating tmp file with subgraph url...${LOG_END}"

cd $WORKDIR

rm -f subgraph_api
mktemp subgraph_api
echo $SUBGRAPH_API | sed 's/.*SUBGRAPH_API: //' > subgraph_api

API_TO_PARSE=$(head -n 1 subgraph_api)
echo Fetched api: ${API_TO_PARSE}

printf "${LOG_START}Starting dApp...${LOG_END}"

REACT_APP_SUBGRAPH_API=${API_TO_PARSE} yarn start