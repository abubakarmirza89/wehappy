document.addEventListener('DOMContentLoaded', () => {
  const draft = document.getElementById('id_draft');
  if (!draft) return;
  const toolbar = document.createElement('div');
  toolbar.setAttribute('aria-label', 'Policy formatting');
  for (const [label, example] of [
    ['Heading', '\n\n## Section heading\n\n'],
    ['Paragraph', '\n\nParagraph text.\n\n'],
    ['List', '\n\n- First item\n- Second item\n\n'],
    ['Link', '[Link text](https://example.com)'],
  ]) {
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = label;
    button.addEventListener('click', () => {
      draft.setRangeText(example, draft.selectionStart, draft.selectionEnd, 'end');
      draft.focus();
    });
    toolbar.appendChild(button);
  }
  draft.before(toolbar);
  const hint = document.createElement('p');
  hint.textContent = 'Use the formatting controls or Markdown. Save the draft, then preview it before publishing.';
  toolbar.before(hint);
});
