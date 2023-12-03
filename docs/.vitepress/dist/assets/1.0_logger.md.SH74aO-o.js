import{_ as s,o as a,c as i,R as e}from"./chunks/framework.b72w6-dR.js";const c=JSON.parse('{"title":"Logger","description":"","frontmatter":{},"headers":[],"relativePath":"1.0/logger.md","filePath":"1.0/logger.md"}'),n={name:"1.0/logger.md"},t=e(`<h1 id="logger" tabindex="-1">Logger <a class="header-anchor" href="#logger" aria-label="Permalink to &quot;Logger&quot;">​</a></h1><p>Event based logger object. More information at <a href="/Riptide/guide/guides/logging.html">logger</a>.</p><h3 id="events" tabindex="-1">Events <a class="header-anchor" href="#events" aria-label="Permalink to &quot;Events&quot;">​</a></h3><p>Events consist of an unix timestamp, a level and an attached message.</p><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">type</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Event </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Time</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Type</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Info&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Debug&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Warn&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Error&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Fatal&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>The <code>Error</code> log level doesn&#39;t stop code execution - <code>Fatal</code> on the other hand, halts execution and throws an error to the developer console.</p><h2 id="types" tabindex="-1">Types <a class="header-anchor" href="#types" aria-label="Permalink to &quot;Types&quot;">​</a></h2><h3 id="event" tabindex="-1">Event <a class="header-anchor" href="#event" aria-label="Permalink to &quot;Event&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Event </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Time</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Type</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Info&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Debug&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Warn&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Error&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Fatal&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><h2 id="methods" tabindex="-1">Methods <a class="header-anchor" href="#methods" aria-label="Permalink to &quot;Methods&quot;">​</a></h2><h3 id="new" tabindex="-1">new <a class="header-anchor" href="#new" aria-label="Permalink to &quot;new&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">new</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">() → Logger</span></span></code></pre></div><p>Constructs a Logger.</p><h3 id="info" tabindex="-1">Info <a class="header-anchor" href="#info" aria-label="Permalink to &quot;Info&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Info</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event</span></span></code></pre></div><p>Logs at the <code>Info [🔵]</code> level.</p><h3 id="debug" tabindex="-1">Debug <a class="header-anchor" href="#debug" aria-label="Permalink to &quot;Debug&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Debug</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event</span></span></code></pre></div><p>Logs at the <code>Debug [🟡]</code> level.</p><h3 id="warn" tabindex="-1">Warn <a class="header-anchor" href="#warn" aria-label="Permalink to &quot;Warn&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Warn</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event</span></span></code></pre></div><p>Logs at the <code>Warn [🟠]</code> level.</p><h3 id="error" tabindex="-1">Error <a class="header-anchor" href="#error" aria-label="Permalink to &quot;Error&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Error</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event</span></span></code></pre></div><p>Logs at the <code>Error [🔴]</code> level.</p><h3 id="fatal" tabindex="-1">Fatal <a class="header-anchor" href="#fatal" aria-label="Permalink to &quot;Fatal&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Fatal</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event</span></span></code></pre></div><p>Logs at the <code>Fatal [❌]</code> level and spits out an error to the developer console, halting code execution.</p><h3 id="assert" tabindex="-1">Assert <a class="header-anchor" href="#assert" aria-label="Permalink to &quot;Assert&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Assert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Condition</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: boolean,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event?</span></span></code></pre></div><p>Performs a soft assertion at the <code>Error [🔴]</code> level.</p><h3 id="assert-1" tabindex="-1">Assert <a class="header-anchor" href="#assert-1" aria-label="Permalink to &quot;Assert&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">FatalAssert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Condition</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: boolean,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → Event?</span></span></code></pre></div><p>Performs a fatal assertion at the <code>Fatal [❌]</code> level, halting execution and erroring to the developer console if the condition is false.</p><h3 id="onevent" tabindex="-1">OnEvent <a class="header-anchor" href="#onevent" aria-label="Permalink to &quot;OnEvent&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">OnEvent</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Type</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: EventType,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Callback</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (Event) → void</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → () → void </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">-- Used to disconnect</span></span></code></pre></div><p>Called every time an event of the specified level happens.</p><p>As an example, this logs every debug event to the developer console:</p><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Logger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">OnEvent</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Debug&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">function</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(Event)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">\`[🟡][🕒{Event.Time}]: {Event.Message}\`</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">end</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><h3 id="onanyevent" tabindex="-1">OnAnyEvent <a class="header-anchor" href="#onanyevent" aria-label="Permalink to &quot;OnAnyEvent&quot;">​</a></h3><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Logger.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">OnAnyEvent</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    self</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: Logger,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Callback</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: (Event) → void</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) → () → void </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">-- Used to disconnect</span></span></code></pre></div><p>Called every time any event happens.</p>`,42),l=[t];function h(p,k,r,E,d,o){return a(),i("div",null,l)}const y=s(n,[["render",h]]);export{c as __pageData,y as default};
