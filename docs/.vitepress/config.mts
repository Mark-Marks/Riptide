import { defineConfig } from 'vitepress';

function nav() {
	return [
		{ text: 'Guide', link: '/guide/introduction/what-is-riptide' },
		{ text: 'API', link: '/1.0/riptide' },
	]
}

function sidebar() {
	return {
		'/guide/': [
			{
				text: 'Introduction',
				items: [
					{ text: 'What is Riptide?', link: '/guide/introduction/what-is-riptide' },
					{ text: 'Getting Started', link: '/guide/introduction/getting-started' }
				]
			},
			{
				text: 'Guides',
				items: [
					{ text: 'Style Guide', link: '/guide/guides/style-guide.md' },
					{ text: 'Ignition', link: '/guide/guides/ignition.md' },
					{ text: 'Networking', link: '/guide/guides/networking.md' },
					{ text: 'Logging', link: '/guide/guides/logging.md' }
				]
			},
		],
		'/1.0/': [
			{
				text: 'API',
				items: [
					{ text: 'Riptide', link: '/1.0/riptide' },
					{ text: 'Logger', link: '/1.0/logger' },
					{
						text: 'Networking',
						items: [
							{
								text: 'Event',
								link: '/1.0/networking/event',
								items: [
									{ text: 'ServerEvent', link: '/1.0/networking/serverevent' },
									{ text: 'ClientEvent', link: '/1.0/networking/clientevent' }
								]
							},
							{ text: 'Function', link: '/1.0/networking/function' }
						]
					}
				]
			}
		]
	}
}

// https://vitepress.dev/reference/site-config
export default defineConfig({
	title: "Riptide",
	description: "A blazingly fast framework.",
	base: "/Riptide/",
	head: [
		['link', { rel: 'icon', href: '/favicon.png' }]
	],

	themeConfig: {
		logo: "/logo.png",
		// https://vitepress.dev/reference/default-theme-config
		nav: nav(),

		sidebar: sidebar(),

		socialLinks: [
			{ icon: 'github', link: 'https://github.com/mark-marks/riptide' }
		],
	}
});
