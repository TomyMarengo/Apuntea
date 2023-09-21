// TOOLTIP
const tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]'),
);
const tooltipList = tooltipTriggerList.map((tooltipTriggerEl) => {
    return new bootstrap.Tooltip(tooltipTriggerEl);
});

// TOAST
const liveToast = document.getElementById('liveToast');

// const copyButtons = document.getElementsByClassName('copy-button');

for (let copyButton of document.getElementsByClassName('copy-button')) {
    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(liveToast)
    copyButton.addEventListener('click', () => {
        toastBootstrap.show()
    })
}