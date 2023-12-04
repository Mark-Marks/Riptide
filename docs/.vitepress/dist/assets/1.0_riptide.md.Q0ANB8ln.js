import{_ as s,o as i,c as a,R as n}from"./chunks/framework.b72w6-dR.js";const y=JSON.parse('{"title":"Riptide","description":"","frontmatter":{},"headers":[],"relativePath":"1.0/riptide.md","filePath":"1.0/riptide.md"}'),t={name:"1.0/riptide.md"},h=n(`<h1 id="riptide" tabindex="-1">Riptide <a class="header-anchor" href="#riptide" aria-label="Permalink to &quot;Riptide&quot;">​</a></h1><p>A blazing fast framework, designed with developers in mind.</p><h2 id="types" tabindex="-1">Types <a class="header-anchor" href="#types" aria-label="Permalink to &quot;Types&quot;">​</a></h2><h3 id="clientevent" tabindex="-1">ClientEvent <a class="header-anchor" href="#clientevent" aria-label="Permalink to &quot;ClientEvent&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">ClientEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Id</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Reliable</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: boolean,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Validate</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">unknown) → T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Received</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Signal</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Fire</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ClientEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → (),</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    On</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ClientEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Callback</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → ()) → () → ()</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><h3 id="serverevent" tabindex="-1">ServerEvent <a class="header-anchor" href="#serverevent" aria-label="Permalink to &quot;ServerEvent&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Id</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Reliable</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: boolean,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Validate</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">unknown) → T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Received</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Signal</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(Player, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Fire</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Player</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Player, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → (),</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    FireAll</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → (),</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    FireAllExcept</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Except</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Player, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → (),</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    FireList</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">List</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: { Player }, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → (),</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    FireWithFilter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Filter</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (Player) → boolean, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → (),</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    On</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Callback</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (Player, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → ()) → () → (),</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Ratelimit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ServerEvent</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Limit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Interval</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number) → ()</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><h3 id="function" tabindex="-1">Function <a class="header-anchor" href="#function" aria-label="Permalink to &quot;Function&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Function</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Id</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Validate</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">unknown) → T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    SetCallback</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Function</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Callback</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (Player, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → () → (),</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Call</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Function</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Future.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Future</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(boolean, U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    RateLimit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Function</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Limit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Interval</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number) → ()</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><h3 id="singleton" tabindex="-1">Singleton <a class="header-anchor" href="#singleton" aria-label="Permalink to &quot;Singleton&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Singleton </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Init</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ( () → () )?,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Start</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ( () → () )?,</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Stepped</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ( (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Time</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number, </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">DeltaTime</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number) → () )?,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Heartbeat</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ( (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">DeltaTime</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number) → () )?,</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    [string]: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">any) → </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">any</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><h2 id="references" tabindex="-1">References <a class="header-anchor" href="#references" aria-label="Permalink to &quot;References&quot;">​</a></h2><h3 id="future" tabindex="-1">Future <a class="header-anchor" href="#future" aria-label="Permalink to &quot;Future&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Future</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Future</span></span></code></pre></div><p>Reference to <a href="https://util.redblox.dev/future.html" target="_blank" rel="noreferrer">Future</a>, a lightweight class to represent asynchronous functions</p><h3 id="guard" tabindex="-1">Guard <a class="header-anchor" href="#guard" aria-label="Permalink to &quot;Guard&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Guard</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Guard</span></span></code></pre></div><p>Reference to <a href="https://util.redblox.dev/guard.html" target="_blank" rel="noreferrer">Guard</a>, a runtime type checker</p><h3 id="anonymoussignal" tabindex="-1">AnonymousSignal <a class="header-anchor" href="#anonymoussignal" aria-label="Permalink to &quot;AnonymousSignal&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">AnonymousSignal</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Signal</span></span></code></pre></div><p>Reference to <a href="https://util.redblox.dev/signal.html" target="_blank" rel="noreferrer">Signal</a>, a blazingly fast Signal implementation</p><h3 id="defaultlogger" tabindex="-1">DefaultLogger <a class="header-anchor" href="#defaultlogger" aria-label="Permalink to &quot;DefaultLogger&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">DefaultLogger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger</span></span></code></pre></div><p>Riptide&#39;s default logger, which logs all debug messages to the developer console</p><h2 id="classes" tabindex="-1">Classes <a class="header-anchor" href="#classes" aria-label="Permalink to &quot;Classes&quot;">​</a></h2><h3 id="event" tabindex="-1">Event <a class="header-anchor" href="#event" aria-label="Permalink to &quot;Event&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Event</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Event</span></span></code></pre></div><p><a href="/Riptide/1.0/networking/event.html">A powerful networking implementation</a></p><h3 id="logger" tabindex="-1">Logger <a class="header-anchor" href="#logger" aria-label="Permalink to &quot;Logger&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Logger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger</span></span></code></pre></div><p><a href="/Riptide/1.0/logger.html">A powerful logger based around events</a></p><h2 id="methods" tabindex="-1">Methods <a class="header-anchor" href="#methods" aria-label="Permalink to &quot;Methods&quot;">​</a></h2><h3 id="ignite" tabindex="-1">Ignite <a class="header-anchor" href="#ignite" aria-label="Permalink to &quot;Ignite&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Ignite</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Verbose</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: boolean? </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">-- Log every event to the console?</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Future</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;number&gt;</span></span></code></pre></div><p>Starts Riptide, loading all of the added singletons. Returns the time it took to load wrapped in a Future.</p><h3 id="addsingleton" tabindex="-1">AddSingleton <a class="header-anchor" href="#addsingleton" aria-label="Permalink to &quot;AddSingleton&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">AddSingleton</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Singleton</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: ModuleScript) → ()</span></span></code></pre></div><p>Registers a singleton.</p><h3 id="addsingletons" tabindex="-1">AddSingletons <a class="header-anchor" href="#addsingletons" aria-label="Permalink to &quot;AddSingletons&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">AddSingletons</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Path</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Instance) → ()</span></span></code></pre></div><p>Shallowly registers singletons from under an instance.</p><h3 id="cachedsignal" tabindex="-1">CachedSignal <a class="header-anchor" href="#cachedsignal" aria-label="Permalink to &quot;CachedSignal&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">CachedSignal</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Name</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string) → Signal</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;T...&gt;</span></span></code></pre></div><p>Creates a new cached signals.</p><p>Cached signals utilize <a href="https://util.redblox.dev/signal.html" target="_blank" rel="noreferrer">Signal</a> under the hood. All cached signals are put into a cache within Riptide, which can be accessed from anywhere within your codebase.</p><h3 id="function-1" tabindex="-1">Function <a class="header-anchor" href="#function-1" aria-label="Permalink to &quot;Function&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Function</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&lt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Name</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    ValidateArgs</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">unknown) → T</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    ValidateReturn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">unknown) → U</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">...</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Function</span></span></code></pre></div>`,47),l=[h];function e(k,p,r,E,d,g){return i(),a("div",null,l)}const c=s(t,[["render",e]]);export{y as __pageData,c as default};