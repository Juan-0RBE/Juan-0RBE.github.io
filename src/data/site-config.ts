import avatar from '../assets/images/avatarJ.jpeg';
import type { SiteConfig } from '../types';

const siteConfig: SiteConfig = {
    website: 'https://example.com',
    avatar: {
        src: avatar,
        alt: 'Juan OB'
    },
    title: 'Juan Andrés Orjuela Bello',
    subtitle: 'Actual estudiante de Ingeniería de Sistemas',
    description: 'Astro.js and Tailwind CSS theme for blog and portfolio by justgoodui.com',
    // image: {
    //     src: '/dante-preview.jpg',
    //     alt: 'Dante - Astro.js and Tailwind CSS theme'
    // },
    headerNavLinks: [
        {
            text: 'Página principal',
            href: '/'
        },
        // {
        //     text: 'Projects',
        //     href: '/projects'
        // },
        // {
        //     text: 'Blog',
        //     href: '/blog'
        // },
        // {
        //     text: 'Tags',
        //     href: '/tags'
        // },
        {
            text: 'Evidencias',
            href: '/evidencias'
        },
        {
            text: 'Presentación',
            href: '/presentacion'
        }
    ],
    footerNavLinks: [
        {
            text: 'Sobre mí',
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
            text: 'El tema que usé',
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
        title: 'Hola, permíteme presentarme.',
        text: "Mi nombre es Juan Andrés Orjuela Bello y actualmente estudio Ingeniería de Sistemas en la Universidad El Bosque, con un interés particular en la programación. Mis habilidades actuales me han permitido desarrollar programas en Java y aplicaciones web. Tengo mucho interés en aprender sobre nuevas tecnologías a medida que avanzo en mis estudios. \n\nNo dudes en explorar algunos de mis proyectos de programación en [GitHub](https://github.com/Juan-0RBE?tab=repositories).",
        // image: {
        //     src: hero,
        //     alt: 'A person sitting at a desk in front of a computer'
        // },
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
