const Webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const postcss = require('postcss');

const webpack = require('webpack')
const extractCSS = new ExtractTextPlugin('[name].css')

module.exports = {
    entry: "./src/index.tsx",
    output: {
        path: __dirname + "/dist",
        filename: "bundle.js",
        publicPath: "/dist"
    },
    resolve: {
        extensions: [".js", ".jsx", ".ts", ".tsx", ".json", ".css"],
        modules: [
            path.resolve("./src"),
            path.resolve("./node_modules")
        ]
    },
    module: {
        rules: [
            {
                test: /\.tsx?/,
                loader: "awesome-typescript-loader",
            },
            {
                test: /\.css$/,
                use: [
                    "style-loader",
                    {
                        loader: "css-loader",
                        options: {
                            modules: true, // default is false
                            sourceMap: true,
                            importLoaders: 1,
                            localIdentName: "[name]--[local]--[hash:base64:8]"
                        }
                    },
                    "postcss-loader"
                ]
            }
        ]
    },
    plugins: [
        postcss()
    ],
    devtool: "source-map",
    devServer: {
        port: 3000,
        historyApiFallback: {
            rewrites: [
                { from: /./, to: '/' }
            ]
        }
    },
    plugins: [
        new webpack.LoaderOptionsPlugin({
            postcss: () => {
                return [
                  /* eslint-disable global-require */
                  require('postcss-cssnext')({
                    features: {
                      customProperties: {
                        variables: reactToolboxVariables,
                      },
                    },
                  }),
                  require('postcss-modules-values'),
                  /* eslint-enable global-require */
                ];
            }
        })
    ]
}
