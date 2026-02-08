import avatar from '../assets/images/avatar.jpg';
import hero from '../assets/images/hero.jpg';
import type { SiteConfig } from '../types';

const siteConfig: SiteConfig = {
    website: 'https://example.com',
    avatar: {
        src: avatar,
        alt: 'Ethan Donovan'
    },
    title: 'Juan Andrés Orjuela Bello',
    subtitle: 'Current Systems Engineering Student',
    description: 'Astro.js and Tailwind CSS theme for blog and portfolio by justgoodui.com',
    image: {
        src: '/dante-preview.jpg',
        alt: 'Dante - Astro.js and Tailwind CSS theme'
    },
    headerNavLinks: [
        {
            text: 'Home',
            href: '/'
        },
        {
            text: 'Projects',
            href: '/projects'
        },
        {
            text: 'Blog',
            href: '/blog'
        },
        // {
        //     text: 'Tags',
        //     href: '/tags'
        // },
        {
            text: 'Evidencias',
            href: '/evidencia'
        },
        {
            text: 'Presentacion',
            href: '/presentacion'
        }
    ],
    footerNavLinks: [
        {
            text: 'About',
            href: '/about'
        },
        // {
        //     text: 'Contact',
        //     href: '/contact'
        // },
        // {
        //     text: 'Terms',
        //     href: '/terms'
        // },
        {
            text: 'The theme I used',
            href: 'https://github.com/JustGoodUI/dante-astro-theme'
        }
    ],
    socialLinks: [
        // {
        //     text: 'Dribbble',
        //     href: 'https://dribbble.com/'
        // },
        // {
        //     text: 'Instagram',
        //     href: 'https://instagram.com/'
        // },
        {
            text: 'GitHub',
            href: 'https://github.com/Juan-0RBE'
        }
    ],
    hero: {
        title: 'Hi There, let me introduce myself.',
        text: "My name is Juan Andrés Orjuela Bello, and I am currently studying Systems Engineering at El Bosque University, with a particular interest in programming. My current skills have enabled me to develop programs in Java and web applications. I am very interested in learning about new technologies as I progress in my studies. \n\nFeel free to explore some of my coding endeavors on [GitHub](https://github.com/Juan-0RBE?tab=repositories).",
        image: {
            src: hero,
            alt: 'A person sitting at a desk in front of a computer'
        },
        actions: [
            // {
            //     text: 'Get in Touch',
            //     href: '/contact'
            // }
        ]
    },
    // subscribe: {
    //     enabled: true,
    //     title: 'Subscribe to Dante Newsletter',
    //     text: 'One update per week. All the latest posts directly in your inbox.',
    //     form: {
    //         action: '#'
    //     }
    // },
    postsPerPage: 8,
    projectsPerPage: 8
};

export default siteConfig;
