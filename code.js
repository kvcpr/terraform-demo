exports.handler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: `Good evening from ${process.env.ENV_NAME}!` }),
  };
};
