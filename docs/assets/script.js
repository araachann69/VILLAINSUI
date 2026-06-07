function copyCode(btn) {
    const code = document.getElementById('load-code');
    if (!code) return;
    navigator.clipboard.writeText(code.textContent.trim()).then(() => {
        btn.textContent = 'Copied!';
        setTimeout(() => { btn.textContent = 'Copy'; }, 2000);
    });
}

document.querySelectorAll('pre code').forEach(block => {
    const wrapper = block.closest('.code-block');
    if (!wrapper) return;
    const copyBtn = wrapper.querySelector('.copy-btn');
    if (!copyBtn) return;
    copyBtn.addEventListener('click', () => {
        navigator.clipboard.writeText(block.textContent.trim()).then(() => {
            copyBtn.textContent = 'Copied!';
            setTimeout(() => { copyBtn.textContent = 'Copy'; }, 2000);
        });
    });
});
