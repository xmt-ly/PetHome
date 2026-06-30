/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
        "./web/**/*.jsp",
        "./web/**/*.jspf"
    ],
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "inverse-surface": "#303030",
                "tertiary-fixed-dim": "#f1c048",
                "on-secondary-fixed": "#002117",
                "primary-container": "#ff8c42",
                "outline-variant": "#ddc1b3",
                "secondary": "#006c53",
                "tertiary-fixed": "#ffdf9c",
                "primary-fixed": "#ffdbc9",
                "on-tertiary": "#ffffff",
                "inverse-primary": "#ffb68d",
                "on-background": "#1b1c1c",
                "surface-container-low": "#f6f3f2",
                "surface": "#fbf9f8",
                "on-secondary": "#ffffff",
                "inverse-on-surface": "#f3f0f0",
                "on-surface-variant": "#564338",
                "secondary-container": "#91f6d3",
                "error": "#ba1a1a",
                "on-secondary-container": "#007259",
                "error-container": "#ffdad6",
                "outline": "#897266",
                "on-tertiary-container": "#513c00",
                "on-primary-fixed-variant": "#763300",
                "tertiary-container": "#d2a42e",
                "surface-container-high": "#eae8e7",
                "surface-bright": "#fbf9f8",
                "background": "#fbf9f8",
                "surface-container": "#f0eded",
                "on-primary-fixed": "#331200",
                "on-tertiary-fixed-variant": "#5b4300",
                "secondary-fixed": "#91f6d3",
                "on-surface": "#1b1c1c",
                "on-primary-container": "#6a2d00",
                "on-primary": "#ffffff",
                "surface-container-highest": "#e4e2e1",
                "on-error": "#ffffff",
                "surface-dim": "#dcd9d9",
                "on-error-container": "#93000a",
                "surface-container-lowest": "#ffffff",
                "on-secondary-fixed-variant": "#00513e",
                "primary": "#9b4500",
                "surface-tint": "#9b4500",
                "tertiary": "#785a00",
                "secondary-fixed-dim": "#74d9b7",
                "on-tertiary-fixed": "#251a00",
                "surface-variant": "#e4e2e1",
                "primary-fixed-dim": "#ffb68d"
            },
            borderRadius: {
                DEFAULT: "0.25rem",
                lg: "0.5rem",
                xl: "0.75rem",
                full: "9999px"
            },
            spacing: {
                gutter: "16px",
                lg: "48px",
                "margin-mobile": "20px",
                "margin-desktop": "120px",
                md: "24px",
                base: "8px",
                sm: "12px",
                xs: "4px",
                xl: "80px"
            },
            fontFamily: {
                "display-lg": ["Plus Jakarta Sans", "PingFang SC", "Noto Sans SC", "system-ui", "sans-serif"],
                "headline-md": ["Plus Jakarta Sans", "PingFang SC", "Noto Sans SC", "system-ui", "sans-serif"],
                "body-md": ["Be Vietnam Pro", "PingFang SC", "Noto Sans SC", "system-ui", "sans-serif"],
                "body-lg": ["Be Vietnam Pro", "PingFang SC", "Noto Sans SC", "system-ui", "sans-serif"],
                "label-sm": ["Plus Jakarta Sans", "PingFang SC", "Noto Sans SC", "system-ui", "sans-serif"]
            },
            fontSize: {
                "display-lg": ["40px", {lineHeight: "1.2", letterSpacing: "-0.02em", fontWeight: "700"}],
                "headline-md": ["24px", {lineHeight: "1.4", fontWeight: "600"}],
                "body-md": ["16px", {lineHeight: "1.6", fontWeight: "400"}],
                "body-lg": ["18px", {lineHeight: "1.6", fontWeight: "400"}],
                "label-sm": ["14px", {lineHeight: "1.4", letterSpacing: "0.05em", fontWeight: "500"}]
            }
        }
    },
    plugins: [
        require("@tailwindcss/forms"),
        require("@tailwindcss/container-queries")
    ]
};
