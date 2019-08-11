!function(){"use strict";var e="undefined"==typeof window?global:window;if("function"!=typeof e.require){var r={},t={},n={},a={}.hasOwnProperty,s="components/",i=function(e,r){var t=0;r&&(0===r.indexOf(s)&&(t=s.length),r.indexOf("/",t)>0&&(r=r.substring(t,r.indexOf("/",t))));var a=n[e+"/index.js"]||n[r+"/deps/"+e+"/index.js"];return a?s+a.substring(0,a.length-".js".length):e},o=/^\.\.?(\/|$)/,c=function(e,r){for(var t,n=[],a=(o.test(r)?e+"/"+r:r).split("/"),s=0,i=a.length;i>s;s++)t=a[s],".."===t?n.pop():"."!==t&&""!==t&&n.push(t);return n.join("/")},l=function(e){return e.split("/").slice(0,-1).join("/")},u=function(r){return function(t){var n=c(l(r),t);return e.require(n,r)}},d=function(e,r){var n={id:e,exports:{}};return t[e]=n,r(n.exports,u(e),n),n.exports},f=function(e,n){var s=c(e,".");if(null==n&&(n="/"),s=i(e,n),a.call(t,s))return t[s].exports;if(a.call(r,s))return d(s,r[s]);var o=c(s,"./index");if(a.call(t,o))return t[o].exports;if(a.call(r,o))return d(o,r[o]);throw new Error('Cannot find module "'+e+'" from "'+n+'"')};f.alias=function(e,r){n[r]=e},f.register=f.define=function(e,t){if("object"==typeof e)for(var n in e)a.call(e,n)&&(r[n]=e[n]);else r[e]=t},f.list=function(){var e=[];for(var t in r)a.call(r,t)&&e.push(t);return e},f.brunch=!0,f._cache=t,e.require=f}}(),require.register("web/static/js/addict",function(e,r,t){"use strict";$(document).ready(function(){function e(){window.location.href="/"}function r(e){for(var r=e.length-1;r>=0;r--)$(".addict.errors").append("<p class='addict error-message'>"+e[r].message+"</p>")}$("#txt-name, #txt-email, #txt-password").keypress(function(e){return 13==e.which?($("#btn-register").click(),$("#btn-login").click(),$("#btn-reset-password").click(),$("#btn-send-reset-password-link").click(),!1):void 0}),$("#btn-register").click(function(){var r=$("#txt-name").val(),t=$("#txt-email").val(),n=$("#txt-password").val(),a=$("#csrf-token").val(),s={name:r,email:t,password:n};$.ajax({type:"POST",url:"/register",headers:{"x-csrf-token":a},data:s}).done(e)}),$("#btn-logout").click(function(){var r=$("#csrf-token").val();$.ajax({type:"DELETE",url:"/logout",headers:{"x-csrf-token":r}}).done(e)}),$("#btn-login").click(function(){var t=$("#txt-email").val(),n=$("#txt-password").val(),a=$("#csrf-token").val();$(".addict.errors").empty();var s={email:t,password:n};$.ajax({type:"POST",url:"/login",headers:{"x-csrf-token":a},data:s}).fail(function(e){r(e.responseJSON.errors)}).done(e)}),$("#btn-reset-password").click(function(){var t=$("#csrf-token").val(),n=$("#txt-password").val(),a=$("#token").val(),s=$("#signature").val();$(".addict.errors").empty();var i={password:n,token:a,signature:s};$.ajax({type:"POST",url:"/reset_password",headers:{"x-csrf-token":t},data:i}).fail(function(e){r(e.responseJSON.errors)}).done(e)}),$("#btn-send-reset-password-link").click(function(){var t=$("#txt-email").val(),n=$("#csrf-token").val();$(".addict.errors").empty();var a={email:t};$.ajax({type:"POST",url:"/recover_password",headers:{"x-csrf-token":n},data:a}).fail(function(){r([{message:"Whoops, something went wrong! Please try again later."}])}).done(e)})})}),require.register("web/static/js/login",function(e,r,t){"use strict";r("./addict")}),require("web/static/js/login");