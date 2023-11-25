"use strict";

const eslintConfigPrettier = require("eslint-config-prettier");
const js = require("@eslint/js");
const globals = require("globals");

module.exports = [
    js.configs.all,
    {
        languageOptions: {
            globals: {
                ...globals.browser,
            },
            sourceType: "module",
        },
        linterOptions: {
            reportUnusedDisableDirectives: true,
        },
        rules: {
            "no-unused-vars": 1,
            "no-var": 1,
            "prefer-const": 1,
            strict: ["warn", "global"],
        },
    },
    eslintConfigPrettier,
    {
        files: ["eslint.config.js"],
        languageOptions: {
            sourceType: "commonjs",
        },
    },
];
