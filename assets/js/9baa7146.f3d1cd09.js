"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[38],{3905:function(e,t,n){n.d(t,{Zo:function(){return p},kt:function(){return m}});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var l=r.createContext({}),c=function(e){var t=r.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},p=function(e){var t=c(e.components);return r.createElement(l.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,l=e.parentName,p=s(e,["components","mdxType","originalType","parentName"]),d=c(n),m=a,k=d["".concat(l,".").concat(m)]||d[m]||u[m]||o;return n?r.createElement(k,i(i({ref:t},p),{},{components:n})):r.createElement(k,i({ref:t},p))}));function m(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,i=new Array(o);i[0]=d;var s={};for(var l in t)hasOwnProperty.call(t,l)&&(s[l]=t[l]);s.originalType=e,s.mdxType="string"==typeof e?e:a,i[1]=s;for(var c=2;c<o;c++)i[c]=n[c];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},4631:function(e,t,n){n.r(t),n.d(t,{frontMatter:function(){return s},contentTitle:function(){return l},metadata:function(){return c},toc:function(){return p},default:function(){return d}});var r=n(7462),a=n(3366),o=(n(7294),n(3905)),i=["components"],s={title:"EKS"},l=void 0,c={unversionedId:"plans/infrastructure/k8s/eks",id:"plans/infrastructure/k8s/eks",title:"EKS",description:"This plan deploys EKS.  In addition, the plan also adds Lacework instrumentation to the cluster.",source:"@site/docs/plans/infrastructure/k8s/eks.md",sourceDirName:"plans/infrastructure/k8s",slug:"/plans/infrastructure/k8s/eks",permalink:"/plans/infrastructure/k8s/eks",editUrl:"https://github.com/lacework-dev/detc-resources/tree/main/docs/docs/plans/infrastructure/k8s/eks.md",tags:[],version:"current",frontMatter:{title:"EKS"},sidebar:"mainSidebar",previous:{title:"AKS",permalink:"/plans/infrastructure/k8s/aks"},next:{title:"GKE",permalink:"/plans/infrastructure/k8s/gke"}},p=[{value:"Required Secrets",id:"required-secrets",children:[],level:2},{value:"Detailed, step by step documentation",id:"detailed-step-by-step-documentation",children:[],level:2},{value:"Plan Launch Commands",id:"plan-launch-commands",children:[],level:2},{value:"Outputs",id:"outputs",children:[],level:2}],u={toc:p};function d(e){var t=e.components,n=(0,a.Z)(e,i);return(0,o.kt)("wrapper",(0,r.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("p",null,"This plan deploys EKS.  In addition, the plan also adds Lacework instrumentation to the cluster."),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Supported Clouds"),": ",(0,o.kt)("inlineCode",{parentName:"p"},"AWS")),(0,o.kt)("h2",{id:"required-secrets"},"Required Secrets"),(0,o.kt)("p",null,(0,o.kt)("inlineCode",{parentName:"p"},"lacework.accss_token"),": Access token to use on the deployed workloads  "),(0,o.kt)("h2",{id:"detailed-step-by-step-documentation"},"Detailed, step by step documentation"),(0,o.kt)("p",null,"All ",(0,o.kt)("inlineCode",{parentName:"p"},"detc")," plans can be reviewed via the ",(0,o.kt)("inlineCode",{parentName:"p"},"--preview")," flag. For all the commands listed below, replace ",(0,o.kt)("inlineCode",{parentName:"p"},"--apply")," with ",(0,o.kt)("inlineCode",{parentName:"p"},"--preview")," to get more details."),(0,o.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,o.kt)("div",{parentName:"div",className:"admonition-heading"},(0,o.kt)("h5",{parentName:"div"},(0,o.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,o.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,o.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,o.kt)("div",{parentName:"div",className:"admonition-content"},(0,o.kt)("p",{parentName:"div"},"You may want to increase verbosity via ",(0,o.kt)("inlineCode",{parentName:"p"},"--verbose")," or even ",(0,o.kt)("inlineCode",{parentName:"p"},"--trace")," to get all details you may want from the preview command."))),(0,o.kt)("h2",{id:"plan-launch-commands"},"Plan Launch Commands"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"detc create \\\n--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/eks.yaml \\\n--apply\n")),(0,o.kt)("h2",{id:"outputs"},"Outputs"),(0,o.kt)("p",null,"Review the step outputs via ",(0,o.kt)("inlineCode",{parentName:"p"},"detc deployments"),". EKS step outputs include the required ",(0,o.kt)("inlineCode",{parentName:"p"},"kubectl")," configuration to connect (deployment name is ",(0,o.kt)("inlineCode",{parentName:"p"},"aws-k8s"),")."))}d.isMDXComponent=!0}}]);