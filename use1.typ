// 基本模板
#import "@preview/rubber-article:0.5.0": *
// #show: article.with()

// For math
#import "@preview/mitex:0.2.5": * // latex 兼容包
#import "@preview/pavemat:0.2.0":* // show matrix beautifully
#import "@preview/physica:0.9.5":* // 数学公式简写
#import "@preview/i-figured:0.2.4"
#show math.equation: i-figured.show-equation.with(only-labeled: false) // 只有引用的公式才会显示编号
#show figure: i-figured.show-figure // 图1.x
#import "@preview/mannot:0.3.0": * // 公式突出
#set math.mat(delim: "[")
#import "@preview/equate:0.3.2" // <breakable>  <dot-product>
// For Code
#import "@preview/lovelace:0.3.0": * // 伪代码算法
                                     // 
// For paper
#import "@preview/showybox:2.0.3": showybox // 彩色盒子
// #set text(font:("Times New Roman","Source Han Serif SC"), size: 12pt) // 设置中英语文字体 小四宋体 英语新罗马 
#import "@preview/tablex:0.0.9": * // 表格
                                   // 
                                   // 
// Tools
#import "@preview/dashy-todo:0.1.1": todo
#import "@preview/cetz:0.4.2" // 绘图

#set page(columns: 1)

// = 目录
// #outline(title: none)
// -----------------------------
#set page(columns: 1)
#show: article

#maketitle(
  title: "The Note of  Reinforcement Learning",
  authors: ("Aoxiang","xuyuan"),
  date: "Oct 2025",
)
#set text(font:("New Computer Modern","Source Han Serif SC"), size: 10pt) // 设置中英语文字体 小四宋体 英语新罗马 
#let 行间距转换(正文字体,行间距) = ((行间距)/(正文字体)-0.75)*1em
#set par(leading: 行间距转换(12,20),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距

#pagebreak()
// == environment
#bibliography(("RL.bib"), title: [
参考文献#v(1em)
],style: "nature")
 