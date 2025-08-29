const sheet = new CSSStyleSheet();
sheet.id = 'insomnia-plugin-hide-login';
sheet.replaceSync(`
  /* Clean-up Header */
  #root .\\[grid-area\\:Header\\] div:has( > span > a[href='https://github.com/Kong/insomnia/stargazers']),
  #root .\\[grid-area\\:Header\\] div > a[href='/auth/login'] {
    display: none !important;
  }
  
  /* Clean-up Navbar */
  #root .grid-template-app-layout.with-navbar {
    grid-template-areas:
      "Header Header"
      "Content Content"
      "Statusbar Statusbar" !important;
  }
  #root .\\[grid-area\\:Navbar\\] {
    display: none !important;
  }
  
  /* Clean-up Sidebar */
  #root #sidebar > div > div:first-child > ol > li:has([data-testid='project']) {
    display: none !important;
  }
      
  /* Clean-up Statusbar */
  #root .\\[grid-area\\:Statusbar\\] > button,
  #root .\\[grid-area\\:Statusbar\\] > div:last-child > div button:not([data-testid])  {
    display: none !important;
  }
  #root .\\[grid-area\\:Statusbar\\] > div:last-child > div a  {
    display: none !important;
  }
  #root .\\[grid-area\\:Statusbar\\] > div:first-child > button:first-child {
    display: none !important;
  }
`);

// remove previous style sheet
document.adoptedStyleSheets = document.adoptedStyleSheets
  ?.filter(it => it.id !== sheet.id) ?? [];

// apply style sheet
document.adoptedStyleSheets.push(sheet);
