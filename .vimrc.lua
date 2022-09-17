vim.api.nvim_exec(
    [[
    nnoremap <silent> <leader><leader><leader> :wa<cr>:!zig-out/bin/digisim core<cr>
    nnoremap <silent> <leader><leader>c :wa<cr>:!zig build -Drelease-fast=true --prominent-compile-errors<cr>
    ]],
    true
)

local cleanupau = vim.api.nvim_create_augroup('DIGISIM_VIMRC_CLEANUP', { clear = true })

local function cleanup()
    vim.api.nvim_exec(
        [[
    unmap <leader><leader><leader>
    unmap <leader><leader>c
    ]],
        true
    )
    vim.api.nvim_del_augroup_by_id(cleanupau)
    vim.notify 'unloaded!'
end

vim.api.nvim_create_autocmd('DirChangedPre', {
    callback = cleanup,
    group = cleanupau,
})
