local map = vim.keymap.set
local nmap = function(keys, cmd, opts)
	map("n", keys, cmd, opts)
end
local imap = function(keys, cmd, opts)
	map("i", keys, cmd, opts)
end
local vmap = function(keys, cmd, opts)
	map("v", keys, cmd, opts)
end

-- keymaps for normal mode
nmap("<leader>a", "maggVG", { desc = "Select all" })
nmap("<leader>ay", "maggVGy`a", { desc = "Select all and copy" })
nmap("<Esc>", ":nohlsearch<CR>:redraw<CR>")
nmap(";", ":")
nmap('<Tab>', ":tabnext<CR>", {desc = "Switch to the next tab"})
nmap('<S-Tab>', ":tabprev<CR>", {desc = "Switch to the next tab"})

-- bufffer mappings
map({ "n", "v" }, "<leader>bh", ":bprevious<CR>", { desc = "Previous buffer" })
map({ "n", "v" }, "<leader>bl", ":bnext<CR>", { desc = "Next buffer" })
map({ "n", "v" }, "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map({ "n", "v" }, "<leader>bb", ":b#<CR>", { desc = "Switch with previous buffer" })
map({ "n", "v" }, "<leader>bp", ":buffers<CR>", { desc = "List buffers" })

-- wincmds
map({ "n", "v" }, "<leader>wh", "<cmd>wincmd h<CR>", { desc = "Focus window (left)" })
map({ "n", "v" }, "<leader>wj", "<cmd>wincmd j<CR>", { desc = "Focus window (right)" })
map({ "n", "v" }, "<leader>wk", "<cmd>wincmd k<CR>", { desc = "Focus window (up)" })
map({ "n", "v" }, "<leader>wl", "<cmd>wincmd l<CR>", { desc = "Focus window (down)" })
map({ "n", "v" }, "<leader>wo", "<cmd>wincmd o<CR>", { desc = "Close all other windows" })
map({ "n", "v" }, "<leader>ws", "<cmd>wincmd s<CR>", { desc = "Split window(horizontally)" })
map({ "n", "v" }, "<leader>wv", "<cmd>wincmd v<CR>", { desc = "Split window(vertically)" })
map({ "n", "v" }, "<leader>wq", "<cmd>wincmd q<CR>", { desc = "Quit window" })
map({ "n", "v" }, "<leader>wT", "<cmd>wincmd T<CR>", { desc = "Break out to a new tab" })
map({ "n", "v" }, "<leader>ww", "<cmd>wincmd w<CR>", { desc = "Switch windows" })
map({ "n", "v" }, "<leader>wx", "<cmd>wincmd x<CR>", { desc = "Swap window with next" })
map({ "n", "v" }, "<leader>w+", "<cmd>wincmd +<CR>", { desc = "Increase height" })
map({ "n", "v" }, "<leader>w-", "<cmd>wincmd -<CR>", { desc = "Decrease height" })
map({ "n", "v" }, "<leader>w_", "<cmd>wincmd _<CR>", { desc = "Max height" })
map({ "n", "v" }, "<leader>w>", "<cmd>wincmd ><CR>", { desc = "Increase width" })
map({ "n", "v" }, "<leader>w<", "<cmd>wincmd <<CR>", { desc = "Decrease width" })
map({ "n", "v" }, "<leader>w|", "<cmd>wincmd |<CR>", { desc = "Max width" })
map({ "n", "v" }, "<leader>w=", "<cmd>wincmd =<CR>", { desc = "Equal height and width" })

nmap("<leader>hv", "<cmd>vert help <CR>", { desc = "Open help (vertical split)" })
nmap("<leader>hh", "<cmd>help <CR>", { desc = "Open help (horizontal split)" })

nmap("<c-j>", ":m .+1<CR>==", { desc = "Move line down" })
nmap("<c-k>", ":m .-2<CR>==", { desc = "Move line up" })
vmap("<c-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vmap("<Esc>", "<Esc>", { desc = "Exit visual mode" })
vmap("<c-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vmap(";", ":", { desc = "Enter command mode" })

imap("<c-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
imap("<c-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
imap('<m-d>', '<cmd>normal! db<CR>', { desc = "Delete word backwards" })
