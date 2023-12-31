/**************************/
/***** COPY BUTTONS *******/
/*************************/

const copyButtons = document.querySelectorAll('.copy-button');
// Función para copiar texto al portapapeles
function copyToClipboard(text) {
    const el = document.createElement('textarea');
    el.value = text;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
}

// Agregar eventos de clic a los botones de copia
copyButtons.forEach(button => {
    button.addEventListener('click', () => {
        const id = button.getAttribute('id').split('.', 1)[0];
        const category = content.find(item => item.id === id).category;
        copyToClipboard(`${baseUrl}/${category === 'directory' ? 'directory' : 'notes'}/${id}`);
    });
});

/**************************/
/***** DOWNLOAD ALL *******/
/*************************/

const downloadSelectedButton = document.getElementById('downloadSelectedButton');

if (downloadSelectedButton)
    downloadSelectedButton.addEventListener('click', () => {
        selectedRowIds.forEach((itemId) => {
            const a = document.createElement('a')
            const {id, category, name } = content.find(item => item.id === itemId)
            a.href = `${baseUrl}/${category === 'directory' ? 'directory' : 'notes'}/${id}/download`
            a.download = name
            document.body.appendChild(a)
            a.click()
            document.body.removeChild(a)
        });
    });

/**************************/
/******* SELECT ALL *******/
/*************************/

const selectAllButton = document.getElementById('selectAllButton');
// Función para seleccionar todas las filas
function selectAll() {
    for (let i = 0; i < rows.length / 2; i++) {
        const checkbox = rows[i].querySelector('.select-checkbox');
        checkbox.checked = true;
        rows[i].classList.add('active-note-found');

        const checkbox2 = rows[i + rows.length / 2].querySelector('.select-checkbox');
        checkbox2.checked = true;
        rows[i + rows.length / 2].classList.add('active-note-found');

        selectedRowIds.add(content[i].id);
    }

    updateSelectedState();
}
if (selectAllButton)
    selectAllButton.addEventListener('click', selectAll);

/**************************/
/****** DESELECT ALL ******/
/*************************/

const deselectAllButton = document.getElementById('deselectAllButton');
function deselectAll() {
    for (let i = 0; i < rows.length / 2; i++) {
        const checkbox = rows[i].querySelector('.select-checkbox');
        checkbox.checked = false;
        rows[i].classList.remove('active-note-found');

        const checkbox2 = rows[i + rows.length / 2].querySelector('.select-checkbox');
        checkbox2.checked = false;
        rows[i + rows.length / 2].classList.remove('active-note-found');

        selectedRowIds.delete(content[i].id);
    }

    updateSelectedState();
}

if (deselectAllButton)
    deselectAllButton.addEventListener('click', deselectAll);


/**************************/
/**** FILES || FOLDERS ****/
/*************************/

const selectOnlyFoldersButton = document.getElementById('selectOnlyFoldersButton');
const selectOnlyFilesButton = document.getElementById('selectOnlyFilesButton');
const selectAllCategoriesButton = document.getElementById('selectAllCategoriesButton');

const searchForm = document.getElementById('searchForm');
const categorySelect = document.getElementById('categorySelect');
const categorySelectContainer = document.getElementById('categorySelectContainer');
const sortBySelect = document.getElementById('sortBySelect');

if (categorySelect.value === "directory") {
    selectOnlyFoldersButton.classList.add('active');
}
else if (categorySelect.value === "all") {
    selectAllCategoriesButton.classList.add('active');
}
else {
    selectOnlyFilesButton.classList.add('active');
}

if (categorySelect.value === "directory" || categorySelect.value === "all") {
    categorySelectContainer.style.width = '0px';
}

selectOnlyFoldersButton.addEventListener('click', () => {
    if (categorySelect.value !== "directory") {
        categorySelect.value = "directory";
        categorySelectContainer.style.display = 'none';
        if (sortBySelect.value === 'score') {
            sortBySelect.value = "modified";
        }

        searchForm.submit();
    }
});

selectAllCategoriesButton.addEventListener('click', () => {
    if (categorySelect.value !== "all") {
        categorySelect.value = "all";
        categorySelectContainer.style.display = 'none';
        if (sortBySelect.value === 'score') {
            sortBySelect.value = "modified";
        }
        searchForm.submit();
    }
});

selectOnlyFilesButton.addEventListener('click', () => {
    if (categorySelect.value === "directory" || categorySelect.value === "all") {
        categorySelectContainer.style.display = 'flex';
        categorySelect.value = "note";
        searchForm.submit();
    }
});

function submitSearchForm() {
    document.getElementById('searchForm').submit();
}