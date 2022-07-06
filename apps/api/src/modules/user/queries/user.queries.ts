export const findUserByUsernameQuery = (username: string) => {
    return {
        where: {
            username: username,
        },
    };
};

export const updateEmailOfUserQuery = (userId: string, email: string) => {
    return {
        data: {
            email: email,
        },
        where: {
            userId: userId,
        },
    };
};
