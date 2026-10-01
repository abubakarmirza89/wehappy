(() => {
  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (!reduced && 'IntersectionObserver' in window) {
    document.documentElement.classList.add('js-motion');
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) { entry.target.classList.add('visible'); observer.unobserve(entry.target); }
      });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
  }
  const menu = document.querySelector('.menu-toggle');
  const nav = document.getElementById('main-nav');
  const closeMenu = () => { nav.classList.remove('open'); menu.setAttribute('aria-expanded', 'false'); };
  menu.addEventListener('click', () => {
    const open = nav.classList.toggle('open'); menu.setAttribute('aria-expanded', String(open));
  });
  nav.querySelectorAll('a').forEach(link => link.addEventListener('click', closeMenu));
  document.addEventListener('keydown', event => { if (event.key === 'Escape') { closeMenu(); } });
  const tabs = [...document.querySelectorAll('[role="tab"]')];
  const selectTab = (id, focus = false) => {
    tabs.forEach(tab => {
      const active = tab.dataset.panel === id;
      tab.setAttribute('aria-selected', String(active)); tab.tabIndex = active ? 0 : -1;
      document.getElementById(`panel-${tab.dataset.panel}`).hidden = !active;
      if (active && focus) tab.focus();
    });
  };
  tabs.forEach((tab, index) => {
    tab.addEventListener('click', () => selectTab(tab.dataset.panel));
    tab.addEventListener('keydown', event => {
      let target;
      if (event.key === 'ArrowRight' || event.key === 'ArrowDown') target = (index + 1) % tabs.length;
      if (event.key === 'ArrowLeft' || event.key === 'ArrowUp') target = (index + tabs.length - 1) % tabs.length;
      if (event.key === 'Home') target = 0;
      if (event.key === 'End') target = tabs.length - 1;
      if (target !== undefined) { event.preventDefault(); selectTab(tabs[target].dataset.panel, true); }
    });
  });
  document.querySelectorAll('[data-next-tab]').forEach(button => {
    button.addEventListener('click', () => selectTab(button.dataset.nextTab, true));
  });
  const responses = {
    Great: 'A good moment is worth noticing. Make a little room for it.',
    Good: 'A little warmth in your day. That counts.',
    Okay: 'You don’t have to feel a certain way. Okay is welcome here.',
    'Not great': 'Tough days happen. A little support can help you feel less alone.',
    Struggling: 'You deserve support. If you feel unsafe, contact local emergency services or someone you trust.'
  };
  document.querySelectorAll('[data-mood]').forEach(button => {
    button.addEventListener('click', () => {
      document.querySelectorAll('[data-mood]').forEach(other => other.setAttribute('aria-pressed', String(other === button)));
      document.getElementById('mood-response').textContent = responses[button.dataset.mood];
    });
  });
})();
