---
name: seo-fundamentals
description: "SEO best practices, meta tags, structured data, Core Web Vitals, technical SEO, and content optimization for search engine visibility."
---

# SEO Fundamentals

> "The best place to hide a dead body is page 2 of Google search results." -- SEO proverb

## When to Use
- Optimizing web pages for search engine visibility and ranking
- Implementing meta tags, Open Graph, and structured data
- Improving Core Web Vitals and page performance
- Conducting technical SEO audits
- Planning content strategy for organic search traffic
- Implementing SEO in single-page applications (SPA) and server-rendered apps
- Setting up sitemaps, robots.txt, and canonical URLs

## Essential Meta Tags

### Title and Description
- **Title tag:** 50-60 characters, primary keyword near the front, unique per page
- **Meta description:** 150-160 characters, compelling call-to-action, include target keyword
- Every page must have a unique title and description
- Avoid keyword stuffing; write for humans, optimize for search

### Open Graph (Social Sharing)
```html
<meta property="og:title" content="Page Title" />
<meta property="og:description" content="Compelling description for social" />
<meta property="og:image" content="https://example.com/og-image.jpg" />
<meta property="og:url" content="https://example.com/page" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="Site Name" />
```

### Twitter Card
```html
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="Page Title" />
<meta name="twitter:description" content="Description for Twitter" />
<meta name="twitter:image" content="https://example.com/twitter-image.jpg" />
```

### Essential Technical Meta Tags
```html
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta name="robots" content="index, follow" />
<link rel="canonical" href="https://example.com/canonical-url" />
<html lang="en">
```

## Structured Data (Schema.org)

### Why Structured Data Matters
- Enables rich results (stars, prices, FAQs, breadcrumbs) in search results
- Helps search engines understand page content semantically
- Increases click-through rates with enhanced SERP features
- Critical for voice search and AI answer generation

### Common Schema Types
- **Article / BlogPosting:** For blog posts and news articles
- **Product:** E-commerce product pages with price, availability, reviews
- **FAQPage:** FAQ sections that can appear as expandable results
- **Organization:** Company information, logo, social profiles
- **BreadcrumbList:** Navigation breadcrumbs shown in search results
- **HowTo:** Step-by-step instructions with optional images
- **LocalBusiness:** Physical business with address, hours, phone
- **Event:** Events with dates, locations, and ticket information

### Implementation Format
Use JSON-LD (preferred by Google) in a script tag:
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title",
  "author": { "@type": "Person", "name": "Author Name" },
  "datePublished": "2025-01-15",
  "image": "https://example.com/image.jpg"
}
</script>
```

### Validation
- Use Google Rich Results Test to validate structured data
- Use Schema.org Markup Validator for general schema validation
- Check Google Search Console for structured data errors and enhancements

## Core Web Vitals

### The Three Metrics
1. **LCP (Largest Contentful Paint):** < 2.5 seconds
   - Measures loading performance; when the largest visible element renders
   - Optimize: preload hero images, use CDN, optimize server response time
   - Avoid: lazy-loading above-the-fold images, render-blocking resources

2. **INP (Interaction to Next Paint):** < 200 milliseconds
   - Measures responsiveness; delay between user input and visual response
   - Optimize: break up long tasks, use `requestIdleCallback`, defer non-critical JS
   - Avoid: long-running JavaScript on the main thread, synchronous layouts

3. **CLS (Cumulative Layout Shift):** < 0.1
   - Measures visual stability; how much the page layout shifts unexpectedly
   - Optimize: set explicit dimensions on images/videos, use `aspect-ratio` CSS
   - Avoid: injecting content above existing content, ads without reserved space

### Performance Optimization
- **Critical rendering path:** Inline critical CSS, defer non-critical CSS
- **Image optimization:** Use WebP/AVIF, responsive images with `srcset`, lazy-load below-fold
- **JavaScript optimization:** Code split, tree shake, defer third-party scripts
- **Font optimization:** Use `font-display: swap`, preload critical fonts, subset fonts
- **Server optimization:** Enable compression (Brotli/gzip), use HTTP/2 or HTTP/3, CDN

### Measurement Tools
- **Google PageSpeed Insights:** Lab and field data, Core Web Vitals assessment
- **Chrome DevTools Lighthouse:** Local performance audits with actionable advice
- **Web Vitals Chrome Extension:** Real-time CWV measurement during browsing
- **Google Search Console:** Field data (real user metrics) across your site
- **CrUX Dashboard:** Chrome User Experience Report for historical field data

## Technical SEO

### Crawlability and Indexing
- **robots.txt:** Control which paths search engines can crawl
- **XML Sitemap:** List all important pages with last-modified dates; submit to Search Console
- **Canonical tags:** Prevent duplicate content issues; self-referencing canonicals are good practice
- **Hreflang:** For multilingual sites, specify language and regional targeting
- **Noindex:** Use `<meta name="robots" content="noindex">` for pages that should not appear in search

### URL Structure
- Use descriptive, keyword-rich URLs: `/blog/seo-best-practices` not `/blog/post?id=123`
- Keep URLs short and readable
- Use hyphens to separate words (not underscores)
- Avoid URL parameters when possible; use path segments instead
- Implement proper 301 redirects when changing URLs
- Maintain a flat site architecture (important pages within 3 clicks of homepage)

### Internal Linking
- Link related content to establish topical clusters
- Use descriptive anchor text (not "click here")
- Ensure every important page is reachable from navigation or internal links
- Fix broken internal links regularly
- Use breadcrumb navigation for hierarchy and user orientation

### Mobile SEO
- Google uses mobile-first indexing: mobile version is the primary version
- Responsive design is the recommended approach
- Ensure text is readable without zooming (16px minimum font size)
- Touch targets should be at least 48x48px with adequate spacing
- Avoid intrusive interstitials (pop-ups) that block content

## Content Optimization

### On-Page SEO Checklist
- H1 tag contains primary keyword (one H1 per page)
- Subheadings (H2, H3) use related keywords and create logical structure
- First paragraph includes the target keyword naturally
- Images have descriptive alt text with keywords where appropriate
- Content is comprehensive and answers the user's search intent
- Internal links to related content on your site
- External links to authoritative sources where relevant

### Search Intent Types
- **Informational:** User wants to learn ("how to optimize images for web")
- **Navigational:** User wants a specific site ("GitHub login")
- **Transactional:** User wants to take action ("buy running shoes online")
- **Commercial investigation:** User is comparing options ("best headphones 2025")

Match your content type to the dominant intent for your target keyword.

### Content Quality Signals
- **E-E-A-T:** Experience, Expertise, Authoritativeness, Trustworthiness
- Show author credentials and expertise
- Cite authoritative sources
- Keep content updated with recent information
- Include original research, data, or insights
- Provide comprehensive coverage of the topic

## SPA and JavaScript SEO
- Use server-side rendering (SSR) or static site generation (SSG) for SEO-critical pages
- Pre-render pages for search engine bots if full SSR is not feasible
- Ensure that client-side navigation updates meta tags and canonical URLs
- Use the History API for clean URLs (not hash-based routing)
- Test rendering with Google's URL Inspection tool in Search Console
- Implement proper `<link rel="canonical">` on every page
- Generate XML sitemaps that include all client-rendered routes

## Monitoring and Analytics
- Set up Google Search Console to monitor indexing, queries, and Core Web Vitals
- Track organic search traffic trends in analytics
- Monitor keyword rankings for target terms
- Set up alerts for indexing drops or crawl errors
- Regularly audit for broken links, missing meta tags, and thin content
- Review Search Console coverage report for excluded or errored pages
