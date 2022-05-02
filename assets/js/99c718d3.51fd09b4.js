"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[867],{3905:function(e,t,n){n.d(t,{Zo:function(){return s},kt:function(){return m}});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function p(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},i=Object.keys(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var l=a.createContext({}),c=function(e){var t=a.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},s=function(e){var t=c(e.components);return a.createElement(l.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},u=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,l=e.parentName,s=p(e,["components","mdxType","originalType","parentName"]),u=c(n),m=r,k=u["".concat(l,".").concat(m)]||u[m]||d[m]||i;return n?a.createElement(k,o(o({ref:t},s),{},{components:n})):a.createElement(k,o({ref:t},s))}));function m(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,o=new Array(i);o[0]=u;var p={};for(var l in t)hasOwnProperty.call(t,l)&&(p[l]=t[l]);p.originalType=e,p.mdxType="string"==typeof e?e:r,o[1]=p;for(var c=2;c<i;c++)o[c]=n[c];return a.createElement.apply(null,o)}return a.createElement.apply(null,n)}u.displayName="MDXCreateElement"},4481:function(e,t,n){n.r(t),n.d(t,{frontMatter:function(){return p},contentTitle:function(){return l},metadata:function(){return c},toc:function(){return s},default:function(){return u}});var a=n(7462),r=n(3366),i=(n(7294),n(3905)),o=["components"],p={title:"Ticketing"},l=void 0,c={unversionedId:"plans/apps/ticketing",id:"plans/apps/ticketing",title:"Ticketing",description:"For an overview of the Ticketing app, please view the central documentation here. This documentation only contains the relevant information for deploying it via the detc tool.",source:"@site/docs/plans/apps/ticketing.md",sourceDirName:"plans/apps",slug:"/plans/apps/ticketing",permalink:"/plans/apps/ticketing",editUrl:"https://github.com/lacework-dev/detc-resources/tree/main/docs/docs/plans/apps/ticketing.md",tags:[],version:"current",frontMatter:{title:"Ticketing"},sidebar:"mainSidebar",previous:{title:"eCommerce",permalink:"/plans/apps/ecommerce"},next:{title:"VoteApp",permalink:"/plans/apps/voteapp"}},s=[{value:"Required secrets",id:"required-secrets",children:[],level:2},{value:"Detailed, step by step documentation",id:"detailed-step-by-step-documentation",children:[],level:2},{value:"Plan Launch Commands",id:"plan-launch-commands",children:[{value:"GCP",id:"gcp",children:[],level:3},{value:"AWS",id:"aws",children:[],level:3}],level:2},{value:"Outputs",id:"outputs",children:[],level:2}],d={toc:s};function u(e){var t=e.components,n=(0,r.Z)(e,o);return(0,i.kt)("wrapper",(0,a.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("p",null,"For an overview of the Ticketing app, please view the central documentation ",(0,i.kt)("a",{parentName:"p",href:"https://docs.google.com/document/d/1jBppUJLL-hD4q96LktEl5i0NyAck-Nla4bz2hF484ts/edit#heading=h.uujexuxbgxvk"},"here"),". This documentation only contains the relevant information for deploying it via the ",(0,i.kt)("inlineCode",{parentName:"p"},"detc")," tool."),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Supported Clouds"),": ",(0,i.kt)("inlineCode",{parentName:"p"},"Google, AWS")),(0,i.kt)("h2",{id:"required-secrets"},"Required secrets"),(0,i.kt)("p",null,(0,i.kt)("inlineCode",{parentName:"p"},"lacework.access_token"),": An access token must be supplied, and this is used when instrumenting the compute instances involved in the ticketing application."),(0,i.kt)("h2",{id:"detailed-step-by-step-documentation"},"Detailed, step by step documentation"),(0,i.kt)("p",null,"All ",(0,i.kt)("inlineCode",{parentName:"p"},"detc")," plans can be reviewed via the ",(0,i.kt)("inlineCode",{parentName:"p"},"--preview")," flag. For all the commands listed below, replace ",(0,i.kt)("inlineCode",{parentName:"p"},"--apply")," with ",(0,i.kt)("inlineCode",{parentName:"p"},"--preview")," to get more details."),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"You may want to increase verbosity via ",(0,i.kt)("inlineCode",{parentName:"p"},"--verbose")," or even ",(0,i.kt)("inlineCode",{parentName:"p"},"--trace")," to get all details you may want from the preview command."))),(0,i.kt)("h2",{id:"plan-launch-commands"},"Plan Launch Commands"),(0,i.kt)("h3",{id:"gcp"},"GCP"),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"Note: Requires the GKE plan to be deployed")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre"},"detc create \\\n--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/gke.yaml \\\n--plan https://raw.githubusercontent.com/lacework-demo/ticketing-app/main/deploy/ticketing-gcp.yaml \\\n--apply\n")),(0,i.kt)("h3",{id:"aws"},"AWS"),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"Note: Requires the EKS plan to be deployed")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre"},"detc create \\\n--plan https://raw.githubusercontent.com/lacework-demo/ticketing-app/main/deploy/ticketing-aws.yaml \\\n--plan https://raw.githubusercontent.com/lacework-dev/detc-resources/main/plans/k8s/eks.yaml \\\n--apply\n")),(0,i.kt)("h2",{id:"outputs"},"Outputs"),(0,i.kt)("p",null,"Review the step outputs via ",(0,i.kt)("inlineCode",{parentName:"p"},"detc deployments"),". The URL for the application can be found in the ",(0,i.kt)("inlineCode",{parentName:"p"},"frontend-k8s")," step."))}u.isMDXComponent=!0}}]);