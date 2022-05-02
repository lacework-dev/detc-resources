"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[320],{3905:function(e,n,t){t.d(n,{Zo:function(){return p},kt:function(){return m}});var r=t(7294);function a(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function i(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function o(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?i(Object(t),!0).forEach((function(n){a(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):i(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function s(e,n){if(null==e)return{};var t,r,a=function(e,n){if(null==e)return{};var t,r,a={},i=Object.keys(e);for(r=0;r<i.length;r++)t=i[r],n.indexOf(t)>=0||(a[t]=e[t]);return a}(e,n);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)t=i[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(a[t]=e[t])}return a}var c=r.createContext({}),l=function(e){var n=r.useContext(c),t=n;return e&&(t="function"==typeof e?e(n):o(o({},n),e)),t},p=function(e){var n=l(e.components);return r.createElement(c.Provider,{value:n},e.children)},d={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},u=r.forwardRef((function(e,n){var t=e.components,a=e.mdxType,i=e.originalType,c=e.parentName,p=s(e,["components","mdxType","originalType","parentName"]),u=l(t),m=a,k=u["".concat(c,".").concat(m)]||u[m]||d[m]||i;return t?r.createElement(k,o(o({ref:n},p),{},{components:t})):r.createElement(k,o({ref:n},p))}));function m(e,n){var t=arguments,a=n&&n.mdxType;if("string"==typeof e||a){var i=t.length,o=new Array(i);o[0]=u;var s={};for(var c in n)hasOwnProperty.call(n,c)&&(s[c]=n[c]);s.originalType=e,s.mdxType="string"==typeof e?e:a,o[1]=s;for(var l=2;l<i;l++)o[l]=t[l];return r.createElement.apply(null,o)}return r.createElement.apply(null,t)}u.displayName="MDXCreateElement"},7267:function(e,n,t){t.r(n),t.d(n,{frontMatter:function(){return s},contentTitle:function(){return c},metadata:function(){return l},toc:function(){return p},default:function(){return u}});var r=t(7462),a=t(3366),i=(t(7294),t(3905)),o=["components"],s={title:"Jenkins"},c=void 0,l={unversionedId:"plans/infrastructure/jenkins",id:"plans/infrastructure/jenkins",title:"Jenkins",description:"This Jenkins plan deploys a server and an agent, both directly on EC2 instances. This Jenkins instance does have a default seed job created (seed job repository can be found here). However, the seed job can be discarded, and the instance can be used just like any other Jenkins instance.",source:"@site/docs/plans/infrastructure/jenkins.md",sourceDirName:"plans/infrastructure",slug:"/plans/infrastructure/jenkins",permalink:"/plans/infrastructure/jenkins",editUrl:"https://github.com/lacework-dev/detc-resources/tree/main/docs/docs/plans/infrastructure/jenkins.md",tags:[],version:"current",frontMatter:{title:"Jenkins"},sidebar:"mainSidebar",previous:{title:"Activity Generation",permalink:"/plans/infrastructure/activity"},next:{title:"AKS",permalink:"/plans/infrastructure/k8s/aks"}},p=[{value:"Required Secrets",id:"required-secrets",children:[],level:2},{value:"Detailed, step by step documentation",id:"detailed-step-by-step-documentation",children:[],level:2},{value:"Plan Launch Commands",id:"plan-launch-commands",children:[],level:2},{value:"Outputs",id:"outputs",children:[],level:2}],d={toc:p};function u(e){var n=e.components,t=(0,a.Z)(e,o);return(0,i.kt)("wrapper",(0,r.Z)({},d,t,{components:n,mdxType:"MDXLayout"}),(0,i.kt)("p",null,"This Jenkins plan deploys a server and an agent, both directly on EC2 instances. This Jenkins instance does have a default seed job created (seed job repository can be found ",(0,i.kt)("a",{parentName:"p",href:"https://github.com/lacework-dev/detc-resources/tree/main/apps/jenkins/job-seeds"},"here"),"). However, the seed job can be discarded, and the instance can be used just like any other Jenkins instance."),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"NOTE: The default job seed is how DETC managed environments are bootstrapped, view the documentation in the job seed folder for more details.")),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Supported Clouds"),": ",(0,i.kt)("inlineCode",{parentName:"p"},"AWS")),(0,i.kt)("h2",{id:"required-secrets"},"Required Secrets"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"lacework.accss_token"),": Access token to use on the deployed workloads",(0,i.kt)("br",{parentName:"p"}),"\n",(0,i.kt)("inlineCode",{parentName:"p"},"lacework.account_name"),": Account name to store in Jenkins secret",(0,i.kt)("br",{parentName:"p"}),"\n",(0,i.kt)("inlineCode",{parentName:"p"},"jenkins.admin_id"),": User name for the admin user",(0,i.kt)("br",{parentName:"p"}),"\n",(0,i.kt)("inlineCode",{parentName:"p"},"jenkins.admin_pass"),": Password for the Jenkins admin user",(0,i.kt)("br",{parentName:"p"}),"\n",(0,i.kt)("inlineCode",{parentName:"p"},"dockerhub.user"),": Dockerhub username for Jenkins secret",(0,i.kt)("br",{parentName:"p"}),"\n",(0,i.kt)("inlineCode",{parentName:"p"},"dockerhub.token"),": Dockerhub access token for Jenkins secret  "),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"NOTE: For Jenkins deployment, your local ",(0,i.kt)("inlineCode",{parentName:"p"},"detc")," configuration must contain Azure, GCP, and AWS credentials or the deployment is not successful. These cloud credentials are made available in the Jenkins instance")),(0,i.kt)("h2",{id:"detailed-step-by-step-documentation"},"Detailed, step by step documentation"),(0,i.kt)("p",null,"All ",(0,i.kt)("inlineCode",{parentName:"p"},"detc")," plans can be reviewed via the ",(0,i.kt)("inlineCode",{parentName:"p"},"--preview")," flag. For all the commands listed below, replace ",(0,i.kt)("inlineCode",{parentName:"p"},"--apply")," with ",(0,i.kt)("inlineCode",{parentName:"p"},"--preview")," to get more details."),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"You may want to increase verbosity via ",(0,i.kt)("inlineCode",{parentName:"p"},"--verbose")," or even ",(0,i.kt)("inlineCode",{parentName:"p"},"--trace")," to get all details you may want from the preview command."))),(0,i.kt)("h2",{id:"plan-launch-commands"},"Plan Launch Commands"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre"},"detc create \\\n--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/jenkins/jenkins.yaml \\\n--apply\n")),(0,i.kt)("h2",{id:"outputs"},"Outputs"),(0,i.kt)("p",null,"Review the step outputs via ",(0,i.kt)("inlineCode",{parentName:"p"},"detc deployments"),". The URL for the Jenkins instance can be found in the ",(0,i.kt)("inlineCode",{parentName:"p"},"jenkins-server")," step, named ",(0,i.kt)("inlineCode",{parentName:"p"},"jenkins_url"),"."))}u.isMDXComponent=!0}}]);