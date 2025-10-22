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
#set par(leading: 行间距转换(13,23),justify: true,first-line-indent: 2em)
#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent() // 修复第一段的问题
#show heading: it =>  {it;par()[#let level=(-0.3em,0.2em,0.2em);#for i in (1, 2, 3) {if it.level==i{v(level.at(int(i)-1))}};#text()[#h(0.0em)];#v(-1em);]} // 修复标题下首行 以及微调标题间距
=  Bellman equation
== basic concept
The agent in time $t$ is in state $S_t$ , takes action $A_t$ , receives reward $R_(t+1)$ , the next state is $S_(t+1)$, it can be represented as a state-action-reward trajectory:
#mitex(`
S_t\xrightarrow{A_t}S_{t+1},R_{t+1}\xrightarrow{A_{t+1}}S_{t+2},R_{t+2}\xrightarrow{A_{t+2}}S_{t+3},R_{t+3}\ldots.
`)

and the discounted return can be defined as: 
$ G_t &= R_(t+1)+gamma R_(t+2)+gamma^2 R_(t+3)+... 
\
&=R_(t+1) +gamma(R_((t+1)+1)+gamma R_((t+1)+2)+... )
&=R_(t+1)+gamma G_(t+1)
 $
 where $ gamma in (0,1)$ is the discount rate , and we also anoted the $R_(t+1)$ as imediate reward #footnote([when agent receives reward, the agent is in time $t+1$]).

#v(0.5em)
Cause $R_t,A_t$ is random variable (even for a fixed $pi$, the $A_t$ is also random#footnote([for example,$P(S_a|S_t)=0.5,P(S_b|S_t)=0.5 quad a!=b$])), so is $G_t$ , we can define the value function as the expectation of $G_t$ :

$ mark(v_pi(mark(s, tag: #<1>, color: #black)), tag: #<2>, color: #red) = EE[G_t|S_t=s] =mark(EE[ G_t|s], tag: #<3>, color: #blue) $
 #annot(<1>, dx: 1em ,dy:-2.2em )[$s$ is a typical state]
 #annot(<2>, dx: -0.5em ,dy:0em )[same as $v(pi,s)$]
 #annot(<3>, dx: -0.5em ,dy:0em )[简写为]
#text(fill:rgb(255,0,0))[Notice that when $|s$ occurs in $EE[G_t|s]$ , it equals to $|S_t=s$.  (And $EE[G_(t+1)|S_(t+1)=1] <-> EE[G_(t+1)|s]$ )]
#v(0.2em)

And $v_pi(s)$ is time-independent, it only releates to the state $s$ and policy $pi$ (for diifferent policies, the action space may be different) .
// #v(0.5em)

 $ "when" quad P(S_(a_i)|S_t)=p_i quad \& quad sum p_i=1 quad  "then" quad v_pi (s) = sum p_i G_(a_i) $ <1.4>

 == simply $v_pi(s)$
From the definition of $G_t$ , we have:
$ v_pi(s) = EE[G_t|s] &= EE[(R_(t+1)+gamma G_(t+1))|s]
\ &= EE[R_(t+1)|S_t=s]+gamma EE[G_(t+1)|S_t=s] $

Notice there $EE[G_(t+1)|S_t=s]$ can,t be simplified to $EE[G_(t+1)|s]$ .
#v(0.5em)
When agent in $s$ at time $t$ , it will be lots of prossible $S_(t+1)=s_i$ when take action $a_i$.  
// and we have 
// $ p(s_i|s,pi)=p_i = pi(A_i|s) $

We first consider $EE[R_(t+1)|s]$ : 

$ EE[R_(t+1)|S_(t)=s] 
&=sum_i^n p(a_i|s,pi)  EE[R_(t+1)|S_t=s,A_t=a_i] \
&=sum_i^n pi(a_i|s)  EE[R_(t+1)|S_t=s,A_t=a_i] \ 
&=sum_i^n pi(a_i|s)   sum _j ^ m p \(r_j|s,a_i\) r_j
$

where $n$ is number of possible actions in $cal(A)_s$ , $m$ is  the number of possible rewards in $cal(R)_(s,a)$


Then we consider $EE[G_(t+1)|S_t=s]$ 


$ EE[G_(t+1)|S_(t)=s] &=sum_i ^(l)P(s_i|s,pi) EE[G_(t+1)|s_i]=sum_i^l  p(s_i|s,pi) v_pi (s_i) \ & =sum_i^l p(a_i|s,pi) p (s_i|a_i,s) v_pi (s_i) =sum_i^l pi(a_i|s) p (s_i|a_i,s) v_pi (s_i)
$

so finally we have:

$ v_pi(s) &= sum_i^n pi(a_i|s) [ sum _j ^ m p \(r_j|s,a_i\) r_j + gamma sum _k ^ l p(s_k|s,a_i) v_pi (s_k) ]  \ &= sum _(a in cal(A)) pi(a|s)[sum_(r in cal(R)_(s))p(r|s,a)r+gamma sum _(s' in cal(S))p(s'|s,a) v_pi (s')] quad  "for all " s in cal(S) $<1.8>

where $l$ is the number of possible states in $cal(S)_(t+1) $ when $S_t=s$.

#let r(a)=text(fill:rgb(255,0,0))[#a]
And it is noteds below:
- The equation  @eqt:1.8 called the Bellman equation is a #r([set]) of linear equations for all $s in cal(S)$ .
- $pi(s),pi(s')$ is unknown and need to be solved.
- what is $pi(a|s)$ ？ #text(fill:rgb(255,0,0))[#mi("\pi(a_i|s)\equiv p(a_i|s,\pi)")]
- $p(r|s,a) !=1,p(s'|s,a)$ represented the #r([system model]) which can capture the strong randomness of the environment—meaning that the agent cannot know the exact subsequent state and reward even if it takes fixed action a in state s.

== Matrix-vector form of the Bellman equation
For the bellman equation mentioned above, we can rewrite in another form (use some different notations).
$ sum _(a in cal(A)) pi(a|s)[sum_(r in cal(R)_(s))p(r|s,a)r+gamma sum _(s' in cal(S))p(s'|s,a) v_pi (s')]  $

Firstly, we consider $sum _(a in cal(A)) pi(a|s) sum_(r in cal(R)_(s))p(r|s,a)r$
$ sum _(a in cal(A)) pi(a|s)sum_(r in cal(R)_(s))p(r|s,a)r &= sum _(a in cal(A))sum_(r in cal(R)_(s)) p(a|pi,s) p(r|s,a) r  \ &=  sum_(r in cal(R)_(s))  p(r|s,pi) r \ &=sum_(r in cal(R)_(s))  p_pi (r|s) r \ & equiv EE[R|s,pi]  equiv r_pi(s)

$
It means the expected imediate reward when agent in state $s$ following policy $pi$ .

Secondly, we consider $sum _(a in cal(A)) pi(a|s) sum _(s' in cal(S))p(s'|s,a) v_pi (s')$

$ sum _(a in cal(A)) pi(a|s) sum _(s' in cal(S))p(s'|s,a) v_pi (s') =  sum _(s' in cal(S)) p(s'|s,pi) v_pi (s') $

And we notation $p(p'|s,pi)$ as 
$ p(s'|s,pi)) equiv p_pi (s'|s) $

so the second part of bellman equation can be rewritten as:

$ sum _(s' in cal(S)) p(s'|s,pi) v_pi (s')=sum _(s' in cal(S))p_pi (s'|s) v_pi (s') $

The bellman equation can be rewritten as:

$ v_pi(s) &= sum _(a in cal(A)) pi(a|s)[sum_(r in cal(R)_(s))p(r|s,a)r+gamma sum _(s' in cal(S))p(s'|s,a) v_pi (s')] \ 
&= r_pi (s)+ sum _(s' in cal(S))p_pi (s'|s) v_pi (s') 
$

For all $s in cal(S)$ , we notation $s$ as $s_i$

$ v_pi (s_i) &= r_pi (s_i) + gamma sum _(s' in cal(S))p_pi (s'|s_i) v_pi (s') \ 
&= r_pi (s_i) + gamma sum _(j)^n p_pi (s_j|s_i) v_pi (s_j)  
 $<1.15>

 where n is the number of states in $cal(S)$ . Then ,we define some vector notation:
 $ v_pi&=[v_pi (s_1),v_pi (s_2),...,v_pi (s_n)]^T\ 
r_pi&=[r_pi (s_1),r_pi (s_2),...,r_pi (s_n)]^T 
  \ P_pi [i,j]&=p_pi (s_j|s_i) quad {P_pi [i,j]>0,sum(P_pi [i,:])=1}
  $

simply @eqt:1.15 in matrix-vector form:

$ v_pi (s_i) &= r_pi (s_i) + gamma P_pi[i,:] v_pi \ 
$

Take $n=1,2,3 ... n$ as example 

$  
  v_pi (s_1) &= r_pi (s_1) + gamma P_pi[1,:] v_pi \
  v_pi (s_2) &= r_pi (s_2) + gamma P_pi[2,:] v_pi \
  ...
  \
  v_pi (s_n) &= r_pi (s_n) + gamma P_pi[n,:] v_pi \

$

 Obviously, we can rewrite above equations in matrix-vector form:

$ v_pi =r_pi + gamma P_pi v_pi $

// And For example 2.6 , we can write down $r_pi$ and $P_pi$ as:
// $ r_pi=[-0.5,1,1,1]^T $
// $ P_pi = mat(
// 0 , 0.2 , 0.1 ;
// 0 , 0.4 , 0.3 ;
// 0 , 0.5 , 0.3 ;
// 0 , 0.2 , 0.7
// ; ) $
// 
== Solving state values from the Bellman equation
=== close form solution
not  applicable in practice because it involves a matrix inversion operation, which still needs  to be calculated by other numerical algorithms
$ v_pi=(I-gamma P_pi)^(-1) r_pi $
// “subsequent” 的中文是 “随后的；后来的；接着发生的”。
=== Iterative solution
In fact, we can directly solve the Bellman  equation using the following iterative algorithm
$ v_(k+1)=r_pi + gamma P_pi v_k $
where $v_0$ is a initial guess of $v_pi$，and when $k->oo$，$v_k$ will converge to $v_pi$.
#v(0.5em)
Proof is below : 

== From state value to action value 
#pagebreak()
// == environment
#bibliography(("RL.bib"), title: [
参考文献#v(1em)
],style: "nature")
 