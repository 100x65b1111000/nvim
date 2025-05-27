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
nmap("<Esc>", ":nohlsearch<CR>")
nmap(";", ":")
nmap('<Tab>', ":tabnext<CR>", {desc = "Switch to the next tab"})
nmap('<S-Tab>', ":tabprev<CR>", {desc = "Switch to the next tab"})

-- bufffer mappings
map({'n', 'v'}, "<leader>bh", ":bprevious<CR>", { desc = "Previous buffer" })
map({'n', 'v'}, "<leader>bl", ":bnext<CR>", { desc = "Next buffer" })
map({'n', 'v'}, "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map({'n', 'v'}, "<leader>bb", ":b#<CR>", { desc = "Switch with previous buffer" })
map({'n', 'v'}, "<leader>bp", ":buffers<CR>", { desc = "List buffers" })

-- wincmds
map({ "n", "v" }, "<leader>wh", ":wincmd h<CR>", { desc = "Focus window (left)" })
map({ "n", "v" }, "<leader>wj", ":wincmd j<CR>", { desc = "Focus window (right)" })
map({ "n", "v" }, "<leader>wk", ":wincmd k<CR>", { desc = "Focus window (up)" })
map({ "n", "v" }, "<leader>wl", ":wincmd l<CR>", { desc = "Focus window (down)" })
map({ "n", "v" }, "<leader>wo", ":wincmd o<CR>", { desc = "Close all other windows" })
map({ "n", "v" }, "<leader>ws", ":wincmd s<CR>", { desc = "Split window(horizontally)" })
map({ "n", "v" }, "<leader>wv", ":wincmd v<CR>", { desc = "Split window(vertically)" })
map({ "n", "v" }, "<leader>wq", ":wincmd q<CR>", { desc = "Quit window" })
map({ "n", "v" }, "<leader>wT", ":wincmd T<CR>", { desc = "Break out to a new tab" })
map({ "n", "v" }, "<leader>ww", ":wincmd w<CR>", { desc = "Switch windows" })
map({ "n", "v" }, "<leader>wx", ":wincmd x<CR>", { desc = "Swap window with next" })
map({ "n", "v" }, "<leader>w+", ":wincmd +<CR>", { desc = "Increase height" })
map({ "n", "v" }, "<leader>w-", ":wincmd -<CR>", { desc = "Decrease height" })
map({ "n", "v" }, "<leader>w_", ":wincmd _<CR>", { desc = "Max height" })
map({ "n", "v" }, "<leader>w>", ":wincmd ><CR>", { desc = "Increase width" })
map({ "n", "v" }, "<leader>w<", ":wincmd <<CR>", { desc = "Decrease width" })
map({ "n", "v" }, "<leader>w|", ":wincmd |<CR>", { desc = "Max width" })
map({ "n", "v" }, "<leader>w=", ":wincmd =<CR>", { desc = "Equal height and width" })

nmap("<leader>hv", ":vert help ", { desc = "Open help (vertical split)" })
nmap("<leader>hh", ":help ", { desc = "Open help (horizontal split)" })

nmap("<c-j>", ":m .+1<CR>==")
nmap("<c-k>", ":m .-2<CR>==")
vmap("<c-j>", ":m >+1<CR>gv=gv")
vmap("<Esc>", ":normal! <Esc>`a:setreg(a, [])")
vmap("<c-k>", ":m <-2<CR>gv=gv ")
vmap(";", ":")

imap("<c-k>", "<Esc>:m .-2<CR>==gi")
imap("<c-j>", "<Esc>:m .+1<CR>==gi")
imap('<m-d>', '<cmd>normal! db<CR>')

map('x', '/', '<C-\\><C-n>`</\\%V', { desc = 'Search forward within visual selection' })
map('x', '?', '<C-\\><C-n>`>?\\%V', { desc = 'Search backward within visual selection' })
