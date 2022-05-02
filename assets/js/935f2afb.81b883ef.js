"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[53],{1109:function(e){e.exports=JSON.parse('{"pluginId":"default","version":"current","label":"Next","banner":null,"badge":false,"className":"docs-version-current","isLast":true,"docsSidebars":{"mainSidebar":[{"type":"link","label":"Introduction","href":"/","docId":"intro"},{"type":"category","label":"Plans","collapsible":true,"collapsed":true,"items":[{"type":"category","label":"Applications","collapsible":true,"collapsed":true,"items":[{"type":"category","label":"Third Party","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"Bank of Anthos","href":"/plans/apps/thirdparty/bankofanthos","docId":"plans/apps/thirdparty/bankofanthos"}]},{"type":"link","label":"eCommerce","href":"/plans/apps/ecommerce","docId":"plans/apps/ecommerce"},{"type":"link","label":"Ticketing","href":"/plans/apps/ticketing","docId":"plans/apps/ticketing"},{"type":"link","label":"VoteApp","href":"/plans/apps/voteapp","docId":"plans/apps/voteapp"}]},{"type":"category","label":"Infrastructure","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"Activity Generation","href":"/plans/infrastructure/activity","docId":"plans/infrastructure/activity"},{"type":"link","label":"Jenkins","href":"/plans/infrastructure/jenkins","docId":"plans/infrastructure/jenkins"},{"type":"category","label":"Kubernetes","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"AKS","href":"/plans/infrastructure/k8s/aks","docId":"plans/infrastructure/k8s/aks"},{"type":"link","label":"EKS","href":"/plans/infrastructure/k8s/eks","docId":"plans/infrastructure/k8s/eks"},{"type":"link","label":"GKE","href":"/plans/infrastructure/k8s/gke","docId":"plans/infrastructure/k8s/gke"}]}]}],"href":"/plans/"},{"type":"category","label":"Extensions","collapsible":true,"collapsed":true,"items":[{"type":"category","label":"Compute","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"azurecompute","href":"/extensions/compute/azurecompute","docId":"extensions/compute/azurecompute"},{"type":"link","label":"ec2instance","href":"/extensions/compute/ec2instance","docId":"extensions/compute/ec2instance"},{"type":"link","label":"gcpcompute","href":"/extensions/compute/gcpcompute","docId":"extensions/compute/gcpcompute"}]},{"type":"category","label":"Infrastructure","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"VPC.AWS","href":"/extensions/infrastructure/VPC.AWS","docId":"extensions/infrastructure/VPC.AWS"}]},{"type":"category","label":"Kubernetes","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"AKS","href":"/extensions/k8s/aks","docId":"extensions/k8s/aks"},{"type":"link","label":"EKS","href":"/extensions/k8s/eks","docId":"extensions/k8s/eks"},{"type":"link","label":"GKE","href":"/extensions/k8s/gke","docId":"extensions/k8s/gke"}]}],"href":"/extensions/"}]},"docs":{"extensions/compute/azurecompute":{"id":"extensions/compute/azurecompute","title":"azurecompute","description":"The azurecompute extension can be used to deploy an Azure compute instance.","sidebar":"mainSidebar"},"extensions/compute/ec2instance":{"id":"extensions/compute/ec2instance","title":"ec2instance","description":"The ec2instance extension can be used to deploy an AWS compute instance.","sidebar":"mainSidebar"},"extensions/compute/gcpcompute":{"id":"extensions/compute/gcpcompute","title":"gcpcompute","description":"The gcpcompute extension can be used to deploy an Azure compute instance.","sidebar":"mainSidebar"},"extensions/index":{"id":"extensions/index","title":"Extensions","description":"The extension resources found in the DETC catalog are \'Wrapper Extensions\'. For details about all extension types, see","sidebar":"mainSidebar"},"extensions/infrastructure/VPC.AWS":{"id":"extensions/infrastructure/VPC.AWS","title":"VPC.AWS","description":"The EKS extension can be used to deploy a simple EKS cluster. As a result of this deployment, a new EKS cluster in a new","sidebar":"mainSidebar"},"extensions/k8s/aks":{"id":"extensions/k8s/aks","title":"AKS","description":"The AKS extension can be used to deploy a simple AKS cluster.","sidebar":"mainSidebar"},"extensions/k8s/eks":{"id":"extensions/k8s/eks","title":"EKS","description":"The EKS extension can be used to deploy a simple EKS cluster. As a result of this deployment, a new EKS cluster in a new","sidebar":"mainSidebar"},"extensions/k8s/gke":{"id":"extensions/k8s/gke","title":"GKE","description":"The GKE extension can be used to deploy a simple GKE cluster.","sidebar":"mainSidebar"},"intro":{"id":"intro","title":"Introduction","description":"What is the Catalog","sidebar":"mainSidebar"},"plans/apps/ecommerce":{"id":"plans/apps/ecommerce","title":"eCommerce","description":"For an overview of the eCommerce application, please view the central documentation here. This documentation only contains the relevant information for deploying it via the detc tool.","sidebar":"mainSidebar"},"plans/apps/thirdparty/bankofanthos":{"id":"plans/apps/thirdparty/bankofanthos","title":"Bank of Anthos","description":"For an overview of the Bank of Anthos example application, view the documentation here. This documentation only contains the relevant information for deploying it via the detc tool.","sidebar":"mainSidebar"},"plans/apps/ticketing":{"id":"plans/apps/ticketing","title":"Ticketing","description":"For an overview of the Ticketing app, please view the central documentation here. This documentation only contains the relevant information for deploying it via the detc tool.","sidebar":"mainSidebar"},"plans/apps/voteapp":{"id":"plans/apps/voteapp","title":"VoteApp","description":"For an overview of the VoteApp, please view the central documentation here. This documentation only contains the relevant information for deploying it via the detc tool.","sidebar":"mainSidebar"},"plans/index":{"id":"plans/index","title":"Plans","description":"For generic documentation about what a plan is, please review the documentation in the detc project here.","sidebar":"mainSidebar"},"plans/infrastructure/activity":{"id":"plans/infrastructure/activity","title":"Activity Generation","description":"Activity generation is used to create texture in a demo environment.  These plans are used to build dedicated \'activity\' compute instances that execute activities against their corresponding cloud environment regularly.","sidebar":"mainSidebar"},"plans/infrastructure/jenkins":{"id":"plans/infrastructure/jenkins","title":"Jenkins","description":"This Jenkins plan deploys a server and an agent, both directly on EC2 instances. This Jenkins instance does have a default seed job created (seed job repository can be found here). However, the seed job can be discarded, and the instance can be used just like any other Jenkins instance.","sidebar":"mainSidebar"},"plans/infrastructure/k8s/aks":{"id":"plans/infrastructure/k8s/aks","title":"AKS","description":"This plan deploys AKS.  In addition, the plan also adds Lacework instrumentation to the cluster.","sidebar":"mainSidebar"},"plans/infrastructure/k8s/eks":{"id":"plans/infrastructure/k8s/eks","title":"EKS","description":"This plan deploys EKS.  In addition, the plan also adds Lacework instrumentation to the cluster.","sidebar":"mainSidebar"},"plans/infrastructure/k8s/gke":{"id":"plans/infrastructure/k8s/gke","title":"GKE","description":"This plan deploys GKE.  In addition, the plan also adds Lacework instrumentation to the cluster.","sidebar":"mainSidebar"}}}')}}]);