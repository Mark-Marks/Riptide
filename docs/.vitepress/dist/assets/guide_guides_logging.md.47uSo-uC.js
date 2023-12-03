import{_ as s,o as i,c as a,R as e}from"./chunks/framework.b72w6-dR.js";const c=JSON.parse('{"title":"Logging","description":"","frontmatter":{},"headers":[],"relativePath":"guide/guides/logging.md","filePath":"guide/guides/logging.md"}'),t={name:"guide/guides/logging.md"},n=e(`<h1 id="logging" tabindex="-1">Logging <a class="header-anchor" href="#logging" aria-label="Permalink to &quot;Logging&quot;">​</a></h1><p>Riptide exposes a logging library, which is based around Events.</p><h2 id="events" tabindex="-1">Events <a class="header-anchor" href="#events" aria-label="Permalink to &quot;Events&quot;">​</a></h2><p>Events consist of an unix timestamp, a level and an attached message.</p><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">type</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Event </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> {</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Time</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: number,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Type</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Info&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Debug&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Warn&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Error&quot; </span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">| </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Fatal&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">    Message</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">: string</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">}</span></span></code></pre></div><p>The <code>Error</code> log level doesn&#39;t stop code execution - <code>Fatal</code> on the other hand, halts execution and throws an error to the developer console.</p><h2 id="loggers" tabindex="-1">Loggers <a class="header-anchor" href="#loggers" aria-label="Permalink to &quot;Loggers&quot;">​</a></h2><p>Loggers are created with <code>.Logger.new</code>:</p><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">local</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Logger </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Riptide.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Logger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">new</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">()</span></span></code></pre></div><p>Loggers expose an API which creates &amp; logs events of every type. Loggers can also be used for asserting - fatally, and non-fatally. Fatal assertions halt code execution and act as type refinements.</p><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Logger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">FatalAssert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">not</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Ignited, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Riptide is already ignited.&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">-- Halts execution &amp; works as a type refinement</span></span>
<span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Logger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">Assert</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(Cookies, </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Grandma didn&#39;t bake cookies today 😟&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;">-- Logs an \`Error\` event, but continues on with execution</span></span></code></pre></div><p>Loggers by default don&#39;t log any events to the developer console, although you can bypass this by hooking your logger - which will be exlpained next.</p><h2 id="hooking" tabindex="-1">Hooking <a class="header-anchor" href="#hooking" aria-label="Permalink to &quot;Hooking&quot;">​</a></h2><p>Loggers can be <strong>hooked</strong>. Hooking allows you to run code for every event of a certain type, or for all events.</p><p>As an example, let&#39;s make a logger log <code>Debug</code> messages to the developer console:</p><div class="language-lua vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">lua</span><pre class="shiki shiki-themes github-light github-dark vp-code"><code><span class="line"><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0;">Logger</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">OnEvent</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;Debug&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">function</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(Event)</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">    print</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">\`[🟡][🕒{Event.Time}]: {Event.Message}\`</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">end</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Running <code>Logger:Debug(&quot;This is a debug&quot;)</code> should print <code>[🟡][🕒INSERT_TIME_HERE]: This is a debug</code> to the console.</p><p>Another example of hooking would be to make a log book, which allows you to view all events &amp; organize them by time, type and their message. You could also utilize hooking to send all <code>Fatal</code> events to some kind of central database, or to alert developers of them.</p>`,18),l=[n];function h(o,p,k,g,r,d){return i(),a("div",null,l)}const u=s(t,[["render",h]]);export{c as __pageData,u as default};
